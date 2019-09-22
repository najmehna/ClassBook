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
//        if currentUser == nil{ signMeIn()}
//        if currentUser != nil{
//            setCurrentProfile(for: currentUser!)
//            performSegue(withIdentifier: "goToHome", sender: self)
//        }else{
//            showAlert(viewController: self, "there was a problem signing you in...")
//        }
        signMeIn()
    }
    
    func signMeIn(){
        guard let myCode = code.text else{ return }
        
        let myCreditential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "verificationID")!, verificationCode: myCode)
        Auth.auth().signIn(with: myCreditential) { (result, error) in
            if error == nil{
                print(result?.user.uid)
                if let uid = result?.user.uid{
//                    if isNewUser(userID: uid){
//                    }else {
//                    }
                    //UserDefaults.standard.set(result?.user.displayName, forKey: "userName")
                    self.setCurrentProfile(for: uid)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    //self.currentUser = uid
                    //UserDefaults.standard.set(uid, forKey: "currentUser")
                    //self.
                }
            }else{
                print("Error signing the user in \(error!.localizedDescription)")
            }
        }
    }
    
    func setCurrentProfile(for currentUser: String){
        let myManager = FirebaseManager()
        myManager.getUserData(for: currentUser) { (success, result) in
            if success{
                if result.count>0{
                print(result)
                let myProfile = Profile(uid: result["uid"] as! String, name: result["name"] as! String, email: result["email"] as! String, birthday: result["birthday"] as! String, pic: result["url"] as! String)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(myProfile) {
                    UserDefaults.standard.set(encoded, forKey: "currentProfile")
                }
                }
                else{
                    UserDefaults.standard.set(nil, forKey: "currentProfile")
//                    let myProfile = Profile(uid: currentUser, name: "New User", email: "", birthday: "", pic: "")
//                    let encoder = JSONEncoder()
//                    if let encoded = try? encoder.encode(myProfile) {
//                        UserDefaults.standard.set(encoded, forKey: "currentProfile")
//                    }
                }
            }
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.layer.cornerRadius = 15
        //myView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }


}

