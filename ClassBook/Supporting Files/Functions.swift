//
//  Functions.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


func showAlert(viewController: UIViewController, _ message: String){
    let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    myAlert.addAction(myAction)
    viewController.present(myAlert, animated: true, completion: nil)
    
}
extension UIImageView {
    func setImageFromUrl(myUrl:String){
        let myStorage = StorageManager()
        myStorage.downloadImage(imageName: myUrl) { (success, data) in
            DispatchQueue.main.async {
                self.image = success ? UIImage(data: data!, scale: 0.5) : UIImage(named: defaultImage)
            }
        }
    }
//    func setImageFromUrl(myUrl:String){
//        let myURL = URL(fileURLWithPath: myUrl)
//        if let myData = try? Data(contentsOf: myURL){
//        self.image = UIImage(data: myData)
//        }else{
//            self.image = UIImage(named: defaultImage)
//        }
//    }
    //?alt=media&token=7ea566f7-01f8-4e35-b0f9-4a3eac83d7a7
    /*Uncommented section
     
    func setImageFromUrl(myUrl: String) {
        print("Download Started\(myUrl)")
        let url:URL = URL(fileURLWithPath: myUrl)
        self.kf.setImage(with: url)
 end of uncommented section*/
    
    
    
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                self.kf.setImage(with: url, placeholder: nil, options:
//                    nil, progressBlock: nil, completionHandler: { (imgSrc, err, nil,
//                        url) in
//                        DispatchQueue.main.async {
//                            self.kf.setImage(with: url)
//                        }
//                })
//            }
//        }
    }

