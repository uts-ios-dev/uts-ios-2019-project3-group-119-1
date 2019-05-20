//
//  MainTabBarController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    var db: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        let auth = AuthenticatedUser()
        auth.signInTest()
        
        db = Database.database().reference()
        db.child("test").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSString
            print("Firebase read: \(value)")
        })
    }
}
