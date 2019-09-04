//
//  QuizViewController.swift
//  Code Quiz
//
//  Created by Felipe on 02/09/19.
//  Copyright (c) 2019 Felipe de Lara. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class QuizViewController: UIViewController {

    // MARK: - Public properties -
    
    var presenter: QuizPresenterInterface!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var wordCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var lowerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var lowerViewY : CGFloat? = nil
    var correctAnswers = [String]()
    var timeCounter = 3
    var timer = Timer()
    weak var keyboardWillShowObserver : NSObjectProtocol?
    weak var keyboardWillHideObserver : NSObjectProtocol?
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordsTableView.delegate = self
        self.wordsTableView.dataSource = self
        self.wordTextField.delegate = self
        wordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.presenter.notifyViewDidLoad()
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardWillShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: self.keyboardWillShow(notification:))
        keyboardWillHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: self.keyboardWillHide(notification:))
        self.presenter.notifyViewDidAppear()
    }
    
    @IBAction func mainButtonPressed(_ sender: Any) {
        self.presenter.mainButtonPressed()
    }
    
    //MARK: - Keyboard
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            //Adjust height so view is not hidden by keyboard
            if UIDevice.current.orientation != UIDeviceOrientation.landscapeLeft
                && UIDevice.current.orientation != UIDeviceOrientation.landscapeRight{
                lowerViewBottomConstraint.constant = keyboardHeight + 16
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        //Put view back in its original place
        lowerViewBottomConstraint.constant = 16
    }
    
    //MARK: - Alerts
    
    func presentAlert(title: String, message: String, actionTitle: String, actionClosure: @escaping (() -> Void)){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default) { UIAlertAction in
                actionClosure()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            }
    }
}

// MARK: - Extensions -

extension QuizViewController: QuizViewInterface {
    func clearTextField() {
        DispatchQueue.main.async {
            self.wordTextField.text = ""
        }
    }
    
    func setTitle(text: String) {
        DispatchQueue.main.async {
            self.titleLabel.text = text
        }
    }
    
    func showVictory() {
        //present alert
        DispatchQueue.main.async {}
    }
    
    func setTable(tableData: [String]) {
        DispatchQueue.main.async {
            self.correctAnswers = tableData
            self.wordsTableView.reloadData()
        }
    }
    
    func setCounter(time: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = time
        }
    }
    
    func setScore(score: String) {
        DispatchQueue.main.async {
            self.wordCounterLabel.text = score
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.loadingView.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.loadingView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateGame(toFitState state: GameState) {
        switch state{
        case .initial:
            self.startResetButton.setTitle("Start", for: .normal)
        default:
            self.startResetButton.setTitle("Reset", for: .normal)
        }
    }
    
    func setupInitialView() {
        self.wordsTableView.delegate = self
        self.wordsTableView.dataSource = self
        
        self.wordTextField.delegate = self
        wordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
}
//MARK: - TextFieldDelegate

extension QuizViewController : UITextFieldDelegate{
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text  else {
            return
        }
        self.presenter.keyworkdsTextViewDidChange(text: text)
    }
}

//MARK: - TableView

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
