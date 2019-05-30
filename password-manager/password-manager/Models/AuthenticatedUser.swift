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
        signInTest()
    }
    
    func signInTest() {
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest", completion: {(r,e) in
            if let result = r {
                print("user: \(result.user.uid)")
                self.user = result.user
                self.informObserversSignedIn()
            }
            if let error = e {
                print("error: \(error.localizedDescription)")
            }
        })
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
