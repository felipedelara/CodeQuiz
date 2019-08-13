//
//  ViewController.swift
//  Code Quiz
//
//  Created by Felipe Ramon de Lara on 10/08/19.
//  Copyright © 2019 Felipe de Lara. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var wordCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var lowerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerView: UIView!
    
    var loadingView : LoadingView?
    var lowerViewY : CGFloat? = nil
    var keywords : [String] = []
    var correctAnswers = [String]()
    var buttonState = ButtonState.start
    var timeCounter = 300
    var timer = Timer()
    
    //MARK: - View events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoadingView()
        let onSuccess : ([String]) -> Void = { result in
            self.keywords = result
            self.stopLoadingView()
        }
        
        
        KeywordsService.request(completionHandler: onSuccess)
    
        self.wordTextField.delegate = self
        wordTextField.addTarget(self, action: #selector(QuizViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        self.wordsTableView.delegate = self
        self.wordsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Loading Indicator

    func showLoadingView(){
        
        let _loadingView = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)![0] as! LoadingView
        self.view.addSubview(_loadingView)
        self.view.bringSubviewToFront(_loadingView)
        _loadingView.activityIndicator.startAnimating()
        
        self.loadingView = _loadingView
    }
    
    @objc func stopLoadingView(){
        DispatchQueue.main.async {
            if let _loadingView = self.loadingView {
                _loadingView.activityIndicator.stopAnimating()
                _loadingView.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Button
    @IBAction func actionButtonPressed(_ sender: Any) {
        buttonStateShouldChange()
    }
    
    func buttonStateShouldChange(){
        if buttonState == .start{
            self.startTimer()
            self.buttonState = .reset
            self.startResetButton.setTitle("Reset", for: .normal)
        }else if buttonState == .reset{
            self.timer.invalidate()
            self.timeCounter = 300
            self.timerLabel.text = "05:00"
            self.buttonState = .start
            self.startResetButton.setTitle("Start", for: .normal)
            self.correctAnswers = []
            self.wordsTableView.reloadData()
            self.wordTextField.text = ""
        }
    }
    
    //MARK: - Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.buttonState == .start{
            buttonStateShouldChange()
        }
        
        if let text = textField.text {
            for keyword in self.keywords{
                if text == keyword.uppercased(){
                    var alreadyExists = false
                    for answer in correctAnswers{
                        if text == answer{
                            alreadyExists = true
                        }
                    }
                    if !alreadyExists{
                        textField.text = ""
                        correctAnswers.append(text)
                        self.wordCounterLabel.text = "\(correctAnswers.count)/\(keywords.count)"
                        self.wordsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            
            if lowerViewY == nil{
                lowerViewY = lowerView.frame.origin.y
                lowerView.frame.origin.y -= keyboardHeight
                lowerView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")

        if let y = lowerViewY{
            lowerView.frame.origin.y = y
            lowerView.layoutIfNeeded()
            lowerViewY = nil
        }
    }
    
    //MARK: - Timer
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        
        let (_, min, sec) = TimeFormat.secondsToHoursMinutesSeconds(seconds: timeCounter)
        if timeCounter > 0 {
            self.timerLabel.text = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
            timeCounter -= 1
        } else{
            self.timer.invalidate()
        }
    }
}

//MARK: - Table
extension QuizViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctAnswers.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCell", for: indexPath) as? KeywordTableViewCell else{
            return UITableViewCell()
        }
        cell.keywordLabel.text = correctAnswers[indexPath.row]
        
        return cell
     }
}
