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
    var user: AuthenticatedUser {
        get { return AuthenticatedUser.instance }
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
    
    // If saving to an existing cred, supply a cred id
    func save(withCredId credId: String? = nil, callback: CredentialCallback) {
        guard validate() else {
            return
        }
        
        let password = self.password!
        let username = self.username!
        let website = self.website!
        
        // Encrypt all details using hash of UID
        let uid = user.uidHash
        let encryptedPassword = password.encrypt(withPassword: uid)
        let encryptedUsername = username.encrypt(withPassword: uid)
        let encryptedWebsite = website.encrypt(withPassword: uid)
        
        // Structure: [PWMRoot]/Credentials/UID/hashOf(USN+URL)/[json]
        let db = Database.database().reference()
        let credHash = "\(username)+\(website)".digest.sha256
        
        // Use cred ID (if supplied, for updating existing details)
        // instead of new hash
        var dbPath = ""
        if let credId = credId {
            dbPath = "Credentials/\(uid)/\(credId)"
        } else {
            dbPath = "Credentials/\(uid)/\(credHash)"
        }
        
        db.child(dbPath)
          .setValue(["username": encryptedUsername,
                     "website": encryptedWebsite,
                     "password": encryptedPassword])
          {(error, dbRef) in
            if let _ = error {
                callback.onSaveError()
            }
            else {
                callback.onSaveSuccessful()
            }
          }
        
    }
    
    // Decrypt this credential using the authenticated user
    func decrypt() throws {
        
        // Only decrypt when the fields are available
        guard let usn = username,
              let pw = password,
              let url = website else {
            throw CredentialError.incompleteCredential
        }
        
        let uid = user.uidHash
        
        username = try usn.decrypt(withPassword: uid)
        password = try pw.decrypt(withPassword: uid)
        website = try url.decrypt(withPassword: uid)
    }
}

protocol CredentialCallback: class {
    func onSaveSuccessful()
    func onSaveError()
}
