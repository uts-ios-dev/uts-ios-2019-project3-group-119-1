//
//  StringExtensions.swift
//  password-manager
//
//  Created by Ba Tran on 20/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import RNCryptor

extension String {
    func isValidEmail() -> Bool {
        // https://stackoverflow.com/a/39550723
        let regexPattern = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        // https://stackoverflow.com/a/26503188
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidUrl() -> Bool {
        // https://stackoverflow.com/a/3809435
        let regexPattern = #"""
        [-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)
        """#
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    // Return a base64-encoded string encrypted with password
    func encrypt(withPassword password: String) -> String {
        let data = self.data(using: .utf8)!
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
        return encryptedData.base64EncodedString()
    }
    
    // Decrypt a base64-encoded password-encrypted string
    func decrypt(withPassword password: String) throws -> String {
        do {
            let encrypted = Data(base64Encoded: self)
            let decryptedData = try RNCryptor.decrypt(data: encrypted!, withPassword: password)
            
            guard let decryptedPassword = String(data: decryptedData, encoding: .utf8) else {
                throw CryptoError.invalidPassword
            }
            return decryptedPassword
        } catch {
            throw CryptoError.invalidPassword
        }
        
    }
}
