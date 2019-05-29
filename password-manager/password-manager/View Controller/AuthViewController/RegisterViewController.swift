//
//  RegisterViewController.swift
//  password-manager
//
//  Created by HochungWong on 29/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var loginView: LoginViewController?
    
    @IBAction func signUp(_ sender: UIButton) {
        self.register(withEmail: emailField.text!, password: passwordField.text!, passwordConfirm: passwordConfirmField.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isEnabled = false
        [emailField, passwordField, passwordConfirmField].forEach({
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
    
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = " "
                return
            }
        }
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let passwordConfirm = passwordConfirmField.text, !passwordConfirm.isEmpty
            else {
                registerButton.isEnabled = false
                return
        }
        registerButton.isEnabled = true
    }
    
    func register(withEmail email: String, password: String, passwordConfirm: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if password != passwordConfirm {
                SCLAlertView().showError("Register Error", subTitle: "Please check your password")
                return
            } else {
                switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                    SCLAlertView().showError("Reigster Error", subTitle: "email already in use")
                    return
                case .some(let error):
                    SCLAlertView().showError("Reigster Error", subTitle: error.localizedDescription)
                    return
                case .none:
                    //no register error
                    //no working
                    self.loginView?.login(withEmail: email, passowrd: password, segue_id: "registerToMainSegue")
                }
            }
        }
    }
}
