//
//  Credential.swift
//  password-manager
//
//  Created by Ba Tran on 20/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import PwGen
import RNCryptor
import Firebase

class Credential {
    var username: String?
    var website: String?
    var password: String?
    let user: AuthenticatedUser!
    
    init() {
        user = AuthenticatedUser()
    }
    
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
        
        guard validate() else {
            return
        }
        
        let encryptedPassword = RNCryptor.encrypt(data: password!.data(using: .utf32)!, withPassword: user.user.uid)
        // decrypt: RNCryptor.decrypt() -> NSData, then use String(data:encoding:)
        
        // Structure: [PWMRoot]/Credentials/UID/USN+URL/[json]
        // [json]: username, url, encryptedPassword
        let db = Database.database().reference()
        db.child("Credentials/\(user.user.uid)/\(username)+\(website)")
          .setValue(["username": username,
                     "url": website,
                     "encryptedPassword": encryptedPassword])
    }
}
