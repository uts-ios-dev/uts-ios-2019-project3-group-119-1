//
//  AuthViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class LoginViewController: UIViewController {
    //outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    //check if sign up button is tapped
    
    @IBAction func signIn(_ sender: UIButton) {
        self.login(withEmail: emailField.text!, passowrd: passwordField.text!, segue_id: "loginToMainSegue")
    }
    
    func login(withEmail email: String, passowrd: String, segue_id: String) {
        Auth.auth().signIn(withEmail: email, password: passowrd) {
            (authResult, error) in
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                SCLAlertView().showError("Login Error", subTitle: "Wrong Password")
            case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:
                SCLAlertView().showError("Login Error", subTitle: "user not found")
            case .some(let error):
                SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
            case .none:
                //no login error
                if let user = authResult?.user {
                    print("user id",user.uid)
                    //keep sign-in state
                    self.userDefaults.set(true, forKey: "usersignedin")
                    self.userDefaults.synchronize()
                    self.performSegue(withIdentifier: segue_id, sender: self)
                }
            }
        }
    }
    
    //detect whether user is editing
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = " "
                return
            }
        }
        guard
            let email = emailField.text, !email.isEmpty,
            let password = passwordField.text, !password.isEmpty
            else {
                signInButton.isEnabled = false
                return
        }
        signInButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.isEnabled = false
        
        [emailField, passwordField].forEach({
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //chehc if the user has logined before on the device
        if userDefaults.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "loginToMainSegue", sender: self)
        }
    }

}
