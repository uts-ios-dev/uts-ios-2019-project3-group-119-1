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
    func signInTest() {
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest", completion: {(u,e) in
            if let user = u {
                print("user: \(user.user.uid)")
            }
            if let error = e {
                print("error: \(error.localizedDescription)")
            }
        })
    }
}
