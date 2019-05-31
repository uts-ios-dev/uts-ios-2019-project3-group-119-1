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
    var authentication: Authentication = Authentication()
     var registerHandler: AuthStateDidChangeListenerHandle!
    //outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func signUp(_ sender: UIButton) {
        if passwordField.text! != passwordConfirmField.text! {
            SCLAlertView().showError("Register Error", subTitle: "Please check your password")
            return
        } else {
            authentication.register(withEmail: emailField.text!, password: passwordField.text!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.isEnabled = false
        [emailField, passwordField, passwordConfirmField].forEach({
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.registerHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "registerToMainSegue", sender: self)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.registerHandler)
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
}
