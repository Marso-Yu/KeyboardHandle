//
//  ViewController.swift
//  KeyboardHandle
//
//  Created by 游淞仁 on 2021/5/17.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var blueViewBottomConstraint: NSLayoutConstraint!
    
    var moveHeight: CGFloat?
    var textFieldTargetY: CGFloat?
    var keyboardShowStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector (keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        textFieldSetting()
    }
    
    func textFieldSetting() {
        if #available(iOS 12.0, *) {
            accountTextField.textContentType = .oneTimeCode
            passwordTextField.textContentType = .oneTimeCode
        } else {
            accountTextField.textContentType = .init(rawValue: "")
            passwordTextField.textContentType = .init(rawValue: "")
        }
        
        passwordTextField.isSecureTextEntry = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let keyboardY = self.view.bounds.size.height - keyboardSize.height
            
            if keyboardShowStatus == true{
                return
            }

            keyboardShowStatus = true
                
            if let textFieldTargetY = textFieldTargetY {
                if textFieldTargetY > keyboardY {
                    moveHeight = textFieldTargetY - keyboardY
                    blueViewBottomConstraint.constant += moveHeight ?? 0
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        blueViewBottomConstraint.constant -= moveHeight ?? 0
        keyboardShowStatus = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldRect = textField.convert(textField.bounds, to:self.view)
        textFieldTargetY = textFieldRect.origin.y + textFieldRect.size.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
