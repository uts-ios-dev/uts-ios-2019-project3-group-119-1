//
//  AuthenticatedUser.swift
//  password-manager
//
//  Created by Ba Tran on 20/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import Firebase

class AuthenticatedUser {
    // Singleton pattern
    private static var _instance: AuthenticatedUser?
    public static var instance: AuthenticatedUser {
        get {
            // Lazy init
            if _instance == nil {
                _instance = AuthenticatedUser()
            }
            return _instance!
        }
        set {
            _instance = newValue
        }
    }
    // End singleton parts
    
    var observers: [AuthenticatedUserObserver]
    
    var user: User!
    var uidHash: String {
        get { return user.uid.digest.sha256 }
    }
    var dbCredentialsPath: String {
        get { return "Credentials/\(uidHash)" }
    }
    
    private init() {
        observers = []
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.user = user
            }
        }
    }
    
    private func informObserversSignedIn() {        
        for observer in observers {
            observer.onSignedIn()
        }
    }
}

protocol AuthenticatedUserObserver: class {
    func onSignedIn()
}
