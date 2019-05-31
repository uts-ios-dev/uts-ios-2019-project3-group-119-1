//
//  AccountSettingsTableViewController.swift
//  password-manager
//
//  Created by HochungWong on 28/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class AccountSettingsTableViewController: UITableViewController {
    var authentication: Authentication = Authentication()
    
    let email = Auth.auth().currentUser?.email
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = self.email
        emailField.isEnabled = false
        saveButton.isEnabled = false
        
        //listen to text filed change
        [currentPasswordField,newPasswordField].forEach({
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        })
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if currentPasswordField.text! == newPasswordField.text! {
            SCLAlertView().showError("Reset Error", subTitle: "New password is same with the old one")
            return
        } else {
            self.authentication.resetPassword(currentPassword: currentPasswordField.text!, newPassword: newPasswordField.text!)
        }
    }
    
    //detect whether user is editing
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = " "
                return
            }
        }
        guard
            let newPassword = newPasswordField.text, !newPassword.isEmpty,
            let currentPassword = currentPasswordField.text, !currentPassword.isEmpty
        else {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
}
