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
        self.resetPassword(currentPassword: currentPasswordField.text!, newPassword: newPasswordField.text!)
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
    
    private func resetPassword(currentPassword: String, newPassword: String) {
        if currentPassword == newPassword {
            SCLAlertView().showError("Reset Error", subTitle: "New password is same with the old one")
            return
        } else {
            Auth.auth().currentUser?.updatePassword(to: newPasswordField.text! ) {
                error in
                if let error = error {
                    SCLAlertView().showError("Reset Error", subTitle: error.localizedDescription)
                } else {
                    SCLAlertView().showSuccess("Reset Successfully", subTitle: "Successful")
                }
            }
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
////         Configure the cell...
//
//        return cell
//    }
//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
