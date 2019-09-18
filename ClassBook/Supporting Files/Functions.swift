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
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
