//
//  Spinner.swift
//  password-manager
//
//  Created by HochungWong on 31/5/19.
//  Copyright © 2019 HochungWong. All rights reserved.
//

import Foundation
import UIKit

var vSpinner: UIView?

extension UIViewController {
    func showSpinner (onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
    }
}
