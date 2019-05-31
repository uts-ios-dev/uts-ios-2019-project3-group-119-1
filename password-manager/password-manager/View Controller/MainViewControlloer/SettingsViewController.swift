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
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.userDefaults.removeObject(forKey: "usersignedin")
            self.userDefaults.synchronize()
            
            if let storyboard = self.storyboard {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "initialViewController") as! UINavigationController
                self.present(initialViewController, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print ("sign out error",error.localizedDescription)
        }
    }
}
