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
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest", completion: {(r,e) in
            if let result = r {
                print("user: \(result.user.uid)")
            }
            if let error = e {
                print("error: \(error.localizedDescription)")
            }
        })
    }
}
