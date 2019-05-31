//
//  NewCredentialsViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit

class EditCredentialsViewController: UITableViewController, CredentialCallback {
    private var credential: Credential!
    public var isNewCredential: Bool = true
    private var credId: String?
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var websiteField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isNewCredential {
            credential = Credential()
            regeneratePassword()
            validateCredentials()
            self.title = "New Password"
        } else {
            usernameField.text = credential.username
            passwordField.text = credential.password
            websiteField.text = credential.website
            self.title = "Edit Password"
        }
        
    }
    
    public func editFor(_ cred: Credential, credId: String) {
        isNewCredential = false
        credential = cred
        self.credId = credId
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
        if isNewCredential {
            credential.save(callback: self)
        }
        // Editing an existing password
        else {
            credential.save(withCredId: credId, callback: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func onSaveError() {
        // TODO: popup:
        self.navigationController?.popViewController(animated: true)
    }
    
    func onSaveSuccessful() {
        // TODO: popup
        self.navigationController?.popViewController(animated: true)
    }
}
