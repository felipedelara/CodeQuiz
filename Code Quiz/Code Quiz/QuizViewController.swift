//
//  ViewController.swift
//  Code Quiz
//
//  Created by Felipe Ramon de Lara on 10/08/19.
//  Copyright © 2019 Felipe de Lara. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var wordCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton!
    
    @IBOutlet weak var lowerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lowerView: UIView!
    
    var lowerViewY : CGFloat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        KeywordsService.request()
    
        
        
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
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            
            if lowerViewY == nil{
                lowerViewY = lowerView.frame.origin.y
                lowerView.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")

        if let y = lowerViewY{
            lowerView.frame.origin.y = y
            lowerViewY = nil
        }
    }
    
}

