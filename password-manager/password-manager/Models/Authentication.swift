//
//  Auth.swift
//  password-manager
//
//  Created by HochungWong on 30/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import Firebase
import SCLAlertView

class Authentication {
    func login(withEmail email: String, passowrd: String) {
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
                }
            }
        }
    }
    
    func register(withEmail email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                SCLAlertView().showError("Reigster Error", subTitle: "email already in use")
                return
            case .some(let error):
                SCLAlertView().showError("Reigster Error", subTitle: error.localizedDescription)
                return
            case .none:
                //no register error
                if let user = authResult?.user {
                    print (user.uid)
                }
            }
        }
    }
}
