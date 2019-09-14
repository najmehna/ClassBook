//
//  ViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-12.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var myView: UIView!
    @IBAction func verifyBtnClicked(_ sender: UIButton) {
        guard var phoneNo = phoneNumber.text else{return}
        if phoneNumber.hasText{
            phoneNo = "+1" + phoneNo
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNo, uiDelegate: nil) { (verificationID, error) in
                if error == nil{
                    UserDefaults.standard.set(verificationID, forKey: "verificationID")
                } else{
                    print("there was something wrong \(error!.localizedDescription)")
                    
                }
            }
        }
        
    }
    @IBAction func signInBtnClicked(_ sender: UIButton) {
        guard let myCode = code.text else{ return }
        
        let myCreditential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "verificationID")!, verificationCode: myCode)
        Auth.auth().signIn(with: myCreditential) { (result, error) in
            if error == nil{
                print(result?.user.phoneNumber)
                if let phoneNumber = result?.user.phoneNumber{
                    self.isNewUser(userID:phoneNumber)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
            }
            }else{
                print("Error signing the user in \(error!.localizedDescription)")
            }
        }
    }
    func isNewUser(userID: String)->Bool{
        var isNew = true
        
        return isNew
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 15
        //myView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }


}

