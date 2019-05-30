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
import SwiftyHash
import Firebase

class Credential {
    var username: String?
    var website: String?
    var password: String?
    let auth: AuthenticatedUser
    
    init() {
        auth = AuthenticatedUser()
    }
    
    func regeneratePassword() {
        // Using PwGen for cryptographic security
        // for now using predefined settings,
        // but given the parametric nature of the library,
        // this can be easily expanded later.
        password = try! PwGen().ofSize(20).withoutSymbols().generate()
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
        guard validate() else {
            return
        }
        
        let password = self.password!
        let username = self.username!
        let website = self.website!
        
        // Encrypt all details using hash of UID
        let uid = auth.user.uid.digest.sha256        
        let encryptedPassword = password.encrypt(withPassword: uid)
        let encryptedUsername = username.encrypt(withPassword: uid)
        let encryptedWebsite = website.encrypt(withPassword: uid)
        
        // Structure: [PWMRoot]/Credentials/UID/hashOf(USN+URL)/[json]
        let db = Database.database().reference()
        let credHash = "\(username)+\(website)".digest.sha256
        let dbPath = "Credentials/\(uid)/\(credHash)"
        db.child(dbPath)
          .setValue(["username": encryptedUsername,
                     "website": encryptedWebsite,
                     "password": encryptedPassword])
        
    }
}
