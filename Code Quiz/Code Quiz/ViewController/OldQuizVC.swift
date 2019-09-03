////
////  ViewController.swift
////  Code Quiz
////
////  Created by Felipe Ramon de Lara on 10/08/19.
////  Copyright © 2019 Felipe de Lara. All rights reserved.
////
//
//import UIKit
//
//class Quiz2ViewController: UIViewController, UITextFieldDelegate {
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var wordTextField: UITextField!
//    @IBOutlet weak var wordsTableView: UITableView!
//    @IBOutlet weak var wordCounterLabel: UILabel!
//    @IBOutlet weak var timerLabel: UILabel!
//    @IBOutlet weak var startResetButton: UIButton!
//    @IBOutlet weak var lowerViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var lowerView: UIView!
//    @IBOutlet weak var loadingView: UIView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    var lowerViewY : CGFloat? = nil
//    var keywords : [String] = []
//    var correctAnswers = [String]()
//    var buttonState = ButtonState.start
//    var timeCounter = 300
//    var timer = Timer()
//
//    weak var keyboardWillShowObserver : NSObjectProtocol?
//    weak var keyboardWillHideObserver : NSObjectProtocol?
//
//    //MARK: - View overrides
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        requestData()
//
//        self.wordTextField.delegate = self
//        wordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
//
//        self.wordsTableView.delegate = self
//        self.wordsTableView.dataSource = self
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        keyboardWillShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: self.keyboardWillShow(notification:))
//        keyboardWillHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: self.keyboardWillHide(notification:))
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if let keyboardWillShowObserver = keyboardWillShowObserver, let keyboardWillHideObserver = keyboardWillHideObserver{
//            NotificationCenter.default.removeObserver(keyboardWillShowObserver)
//            NotificationCenter.default.removeObserver(keyboardWillHideObserver)
//        }
//    }
//
//    func requestData(){
//        self.showLoadingView()
//
//        let onCompletion : (Bool, String, [String]) -> Void = { [unowned vc = self] success, question, answers in
//            DispatchQueue.main.async {
//                if success{
//                    vc.keywords = answers
//                    vc.titleLabel.text = question
//                }else{
//                    vc.presentNetworkFailure()
//                }
//            }
//            vc.stopLoadingView()
//        }
//        KeywordsService.request(completionHandler: onCompletion)
//    }
//
//    //MARK: - Loading Indicator
//    func showLoadingView(){
//        DispatchQueue.main.async { [unowned vc = self] in
//            vc.loadingView.isHidden = false
//            vc.activityIndicator.startAnimating()
//        }
//    }
//
//    @objc func stopLoadingView(){
//        DispatchQueue.main.async { [unowned vc = self] in
//            vc.loadingView.isHidden = true
//            vc.activityIndicator.stopAnimating()
//        }
//    }
//
//    //MARK: - Button
//    @IBAction func actionButtonPressed(_ sender: Any) {
//        gameStateShouldChange()
//    }
//
//    func gameStateShouldChange(){
//        if buttonState == .start{
//            self.startTimer()
//            self.buttonState = .reset
//            self.startResetButton.setTitle("Reset", for: .normal)
//        }else if buttonState == .reset{
//            self.timer.invalidate()
//            self.timeCounter = 300
//            self.timerLabel.text = "05:00"
//            self.wordCounterLabel.text = "0/50"
//            self.buttonState = .start
//            self.startResetButton.setTitle("Start", for: .normal)
//            self.correctAnswers = []
//            self.wordsTableView.reloadData()
//            self.wordTextField.text = ""
//        }
//    }
//
//    //MARK: - Textfield
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if self.buttonState == .start{
//            gameStateShouldChange()
//        }
//
//        guard let text = textField.text  else {
//            return
//        }
//
//        for keyword in self.keywords{
//            if text == keyword.uppercased(){
//                var keyworkAlreadyExists = false
//                
//                for answer in correctAnswers{
//                    if text == answer{
//                        keyworkAlreadyExists = true
//                    }
//                }
//
//                if !keyworkAlreadyExists{
//                    textField.text = ""
//                    correctAnswers.append(text)
//                    self.wordCounterLabel.text = "\(correctAnswers.count)/\(keywords.count)"
//                    self.wordsTableView.reloadData()
//
//                    if self.keywords.count == self.correctAnswers.count{
//                        self.presentVictory()
//                    }
//                }
//            }
//        }
//    }
//
//    //MARK: - Keyboard
//    func keyboardWillShow(notification: Notification) {
//        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
//            print("Notification: Keyboard will show")
//
//            //Adjust height so view is not hidden by keyboard
//            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
//                lowerViewBottomConstraint.constant = keyboardHeight + 16
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    func keyboardWillHide(notification: Notification) {
//        print("Notification: Keyboard will hide")
//
//        //Put view back in its original place
//        lowerViewBottomConstraint.constant = 16
//    }
//
//    //MARK: - Timer
//    func startTimer(){
//        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateCounter() {
//        let (_, min, sec) = TimeFormat.secondsToHoursMinutesSeconds(seconds: timeCounter)
//        if timeCounter > 0 {
//            //Timer still valid
//            self.timerLabel.text = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
//            timeCounter -= 1
//        } else{
//            //Game over
//            self.timer.invalidate()
//            self.presentTimeFinished()
//        }
//    }
//
//    //MARK: - Alerts
//    func presentNetworkFailure(){
//        let alertController = UIAlertController(title: "Error", message: "Could not retrieve data from server.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default) { [unowned vc = self] UIAlertAction in
//            print("Try Again Networking Pressed")
//            vc.requestData()
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    func presentVictory(){
//        let alertController = UIAlertController(title: "Congratulations!", message: "Good job! You found all the answers on time. Keep up with the great work.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Play Again", style: UIAlertAction.Style.default) {  [unowned vc = self] UIAlertAction in
//            print("Play Again Pressed")
//            vc.gameStateShouldChange()
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    func presentTimeFinished(){
//        let alertController = UIAlertController(title: "Time finished", message: "Sorry, time is up! You got \(self.correctAnswers.count) out of \(self.keywords.count) answers.", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default) { [unowned vc = self] UIAlertAction in
//            print("Try Again Pressed")
//            vc.gameStateShouldChange()
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
//
////MARK: - TableView
//extension QuizViewController : UITableViewDelegate, UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return correctAnswers.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath) as? KeywordTableViewCell else{
//            return UITableViewCell()
//        }
//        cell.keywordLabel.text = correctAnswers[indexPath.row]
//
//        return cell
//    }
//}
