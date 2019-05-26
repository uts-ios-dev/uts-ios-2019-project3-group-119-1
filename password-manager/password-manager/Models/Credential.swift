//
//  Credential.swift
//  password-manager
//
//  Created by Ba Tran on 20/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import PwGen

class Credential {
    var username: String?
    var website: String?
    var password: String?
    
    func regeneratePassword() {
        // Using PwGen for cryptographic security
        // for now using predefined settings,
        // but given the parametric nature of the library,
        // this can be easily expanded later.
        password = try! PwGen().ofSize(20).generate()
    }
    
    // Returns whether this credential is valid
    // and thus ready to be saved
    func validate() -> Bool {
        // Is valid when username, website and password
        // all filled
        guard let username = username,
              let website = website,
              let _ = password else {
                return false
        }
        
        // Username must be a valid email
        // and website is a valid url
        return username.isValidEmail() && website.isValidUrl()
    }
    
    func save() {
        print("pressed save")
    }
}
