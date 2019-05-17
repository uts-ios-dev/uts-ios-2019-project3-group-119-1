//
//  ListViewController.swift
//  password-manager
//
//  Created by HochungWong on 17/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordListCell", for: indexPath)
        
        let stackView = cell.contentView.viewWithTag(20000) as! UIStackView
        
        let emailLabel = stackView.viewWithTag(20001) as! UILabel
        emailLabel.text = "test@test.com"
        let urlLabel = stackView.viewWithTag(20002) as! UILabel
        urlLabel.text = "test.abc.com.au"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
