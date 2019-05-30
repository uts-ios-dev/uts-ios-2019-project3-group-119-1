//
//  ListViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UITableViewController, AuthenticatedUserObserver {
    
    var user: AuthenticatedUser!
    var dbRef: DatabaseReference!
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        user = AuthenticatedUser.instance
        credentials = []
        
        user.observers.append(self)
    }
    
    func onSignedIn() {
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reloadData()
    }

    private var credentials: [Credential] = []
    private func reloadData() {
        dbRef.child(user.dbCredentialsPath)
             .observeSingleEvent(of: .value, with: {(snapshot) in
                guard let creds = snapshot.value as? NSDictionary else { return }
                
                // Has credentials to display
                
                // Reset the array
                self.credentials = []
                
                // Rebuilt the array
                for cred in creds.allValues {
                    guard let credentialRaw = cred as? NSDictionary else { return }
                    
                    let credential = Credential()
                    credential.username = credentialRaw["username"] as? String
                    credential.password = credentialRaw["password"] as? String
                    credential.website = credentialRaw["website"] as? String
                    
                    // Attempt decryption
                    do {
                        try credential.decrypt()
                        self.credentials.append(credential)
                    }
                    // TODO: Pop up error
                    catch CryptoError.invalidPassword {
                        print("Invalid password")
                    }
                    catch CredentialError.incompleteCredential {
                        print("Incomplete credential")
                    }
                    catch {
                        print("Unknown error")
                    }
                }
                
                // Reload the table
                self.tableView.reloadData()
             })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PasswordListCell", for: indexPath)
        let credential = credentials[indexPath.row]
        
        let stackView = cell.contentView.viewWithTag(20000) as! UIStackView
        
        let emailLabel = stackView.viewWithTag(20001) as! UILabel
        emailLabel.text = credential.username
        let urlLabel = stackView.viewWithTag(20002) as! UILabel
        urlLabel.text = credential.website
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credentials.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

}
