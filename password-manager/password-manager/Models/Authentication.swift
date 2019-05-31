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
import SwiftOverlays

class Authentication {
    func login(withEmail email: String, passowrd: String) {
        SwiftOverlays.showBlockingWaitOverlayWithText("logging in")
        Auth.auth().signIn(withEmail: email, password: passowrd) {
            (authResult, error) in
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                SCLAlertView().showError("Login Error", subTitle: "Wrong Password")
                SwiftOverlays.removeAllBlockingOverlays()
            case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:
                SCLAlertView().showError("Login Error", subTitle: "user not found")
                SwiftOverlays.removeAllBlockingOverlays()
            case .some(let error):
                SCLAlertView().showError("Login Error", subTitle: error.localizedDescription)
                SwiftOverlays.removeAllBlockingOverlays()
            case .none:
                //no login error
                if let user = authResult?.user {
                    print("user id",user.uid)
                }
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }
    }
    
    func register(withEmail email: String, password: String) {
        SwiftOverlays.showBlockingWaitOverlayWithText("registering")
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                SCLAlertView().showError("Reigster Error", subTitle: "email already in use")
                SwiftOverlays.removeAllBlockingOverlays()
            case .some(let error):
                SCLAlertView().showError("Reigster Error", subTitle: error.localizedDescription)
                SwiftOverlays.removeAllBlockingOverlays()
            case .none:
                //no register error
                if let user = authResult?.user {
                    print (user.uid)
                }
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }
    }
    
    func resetPassword(currentPassword: String, newPassword: String) {
        SwiftOverlays.showBlockingWaitOverlayWithText("resetting")
        Auth.auth().currentUser?.updatePassword(to: newPassword ) {
            error in
            if let error = error {
                SCLAlertView().showError("Reset Error", subTitle: error.localizedDescription)
                SwiftOverlays.removeAllBlockingOverlays()
            } else {
                SCLAlertView().showSuccess("Reset Successfully", subTitle: "Successful")
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }
    }
}
