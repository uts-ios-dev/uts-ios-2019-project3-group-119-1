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

class AuthViewController: UIViewController {
    let alertView: SCLAlertView = SCLAlertView()
    //outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    //check if sign up button is tapped
    var isSignUpTapped = false
    
    @IBAction func signIn(_ sender: UIButton) {
//        do {
//            self.login(withEmail: self.emailField.text!, passowrd: self.passwordField.text!)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        self.login(withEmail: emailField.text!, passowrd: passwordField.text!)
    }
    @IBAction func createUser(_ sender: UIButton) {
//        do {
//            self.register(withEmail: emailField.text!, password: passwordField.text!, passwordConfirm: passwordConfirmField.text!)
//        } catch let error as NSError {
//            print (error.localizedDescription)
//        }
        self.register(withEmail: emailField.text!, password: passwordField.text!, passwordConfirm: passwordConfirmField.text!)
    }
    //when sign up button tap, the 're-enter password" field should be showed
    @IBAction func signUp(_ sender: UIButton) {
        self.isSignUpTapped = true
        if isSignUpTapped {
            self.createUserButton.isHidden = false
            self.passwordConfirmField.isHidden = false
            self.signInButton.isHidden = true
            self.signUpButton.isHidden = true
        }
    }
    
    func login(withEmail email: String, passowrd: String) {
        Auth.auth().signIn(withEmail: email, password: passowrd) {
            (authResult, error) in
            switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                    print("wrong password")
                    SCLAlertView().showError("Login Error", subTitle: "Wrong Password")
                case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:
                    print("user not found")
                    SCLAlertView().showError("Login Error", subTitle: "user not found")
                case .some(let error):
                    print("Login error: \(error.localizedDescription)")
                    SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
                case .none:
                    //no login error
                    if let user = authResult?.user {
                        print("user id",user.uid)
                        //keep sign in state
                        self.userDefaults.set(true, forKey: "usersignedin")
                        self.userDefaults.synchronize()
                        self.performSegue(withIdentifier: "authToMainSegue", sender: self)
                    }
            }
        }
    }
    
    func register(withEmail email: String, password: String, passwordConfirm: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                    print("email already in use")
                    SCLAlertView().showError("Reigster Error", subTitle: "email already in use")
                case .some(let error):
                    SCLAlertView().showError("Reigster Error", subTitle: error.localizedDescription)
                case .none:
                    //no register error
                    self.login(withEmail: email, passowrd: password)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordConfirmField.isHidden = true
        self.createUserButton.isHidden = true
        self.signUpButton.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //chehc if the user has logined before on the device
//        if userDefaults.bool(forKey: "usersignedin") {
//            self.performSegue(withIdentifier: "authToMainSegue", sender: self)
//        }
    }

}
