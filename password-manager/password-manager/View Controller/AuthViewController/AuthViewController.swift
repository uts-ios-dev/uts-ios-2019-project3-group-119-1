//
//  AuthViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
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
        do {
            self.login(withEmail: self.emailField.text!, passowrd: self.passwordField.text!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    @IBAction func createUser(_ sender: UIButton) {
        do {
            self.register(withEmail: emailField.text!, password: passwordField.text!, passwordConfirm: passwordConfirmField.text!)
        } catch let error as NSError {
            print (error.localizedDescription)
        }
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
            let errorCode = error?._code
            if error == nil {
                print("user signed in")
                //keep sign in state
                self.userDefaults.set(true, forKey: "usersignedin")
                self.userDefaults.synchronize()
                self.performSegue(withIdentifier: "authToMainSegue", sender: self)
            } else if errorCode == AuthErrorCode.userNotFound.rawValue {
                //sign up automatically
                print("user not found")
                return
            } else if errorCode == AuthErrorCode.weakPassword.rawValue {
                print("wrong password")
                return
            } else {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
    
    func register(withEmail email: String, password: String, passwordConfirm: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            let errorCode = error?._code
            if error == nil {
                print("user created")
                //login automatically to main
                self.login(withEmail: email, passowrd: password)
            } else if errorCode == AuthErrorCode.emailAlreadyInUse.rawValue {
                print("email already in use")
                return
            } else if password != passwordConfirm {
                print("please check two password are the same")
                return
            } else {
                print(error?.localizedDescription as Any)
                return
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
        if userDefaults.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "authToMainSegue", sender: self)
        }
    }

}
