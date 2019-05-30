//
//  NewCredentialsViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit

class EditCredentialsViewController: UITableViewController {
    private var credential: Credential!
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var websiteField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        credential = Credential()
        regeneratePassword()
        validateCredentials()
    }
    
    private func regeneratePassword() {
        credential.regeneratePassword()
        passwordField.text = credential.password
    }
    
    @IBAction private func onRegenerateTapped() {
        regeneratePassword()
    }
    
    @IBAction private func onUsernameChanged() {
        credential.username = usernameField.text
        validateCredentials()
    }
    
    @IBAction private func onPasswordChanged() {
        credential.password = passwordField.text
        validateCredentials()
    }
    
    @IBAction private func onWebsiteChanged() {
        credential.website = websiteField.text
        validateCredentials()
    }
    
    private func validateCredentials() {
        let isValid = credential.validate()
        saveButton.isEnabled = isValid
    }
    
    @IBAction private func onSaveButtonPressed() {
        credential.save()
    }
}
