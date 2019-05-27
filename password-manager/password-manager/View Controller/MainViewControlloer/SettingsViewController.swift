//
//  SettingsViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func signOutButton() {
        do {
            try Auth.auth().signOut()
            self.userDefaults.removeObject(forKey: "usersignedin")
            self.userDefaults.synchronize()
            
            //not working
            self.performSegue(withIdentifier: "signOutSegue", sender: self)
        } catch let error as NSError {
            print ("sign out error",error.localizedDescription)
        }
    }
}
