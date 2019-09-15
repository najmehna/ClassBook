//
//  Functions.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation
import UIKit

func showAlert(viewController: UIViewController, _ message: String){
    let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    myAlert.addAction(myAction)
    viewController.present(myAlert, animated: true, completion: nil)
    
}
