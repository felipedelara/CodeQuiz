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
    
    var lowerViewY : CGFloat? = nil
    
    var keywords : [String] = []
    
    var correctAnswers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onSuccess : ([String]) -> Void = { result in
            self.keywords = result
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

    //MARK: - Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
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
    
}

extension QuizViewController : UITableViewDelegate, UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
