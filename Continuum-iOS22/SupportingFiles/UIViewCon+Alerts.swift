//
//  UIViewCon+Alerts.swift
//  Continuum-iOS22
//
//  Created by Ivan Ramirez on 11/7/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertControllerWith(title: String, message: String ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK, I Promise", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}
