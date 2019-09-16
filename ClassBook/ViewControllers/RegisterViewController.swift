//
//  RegisterViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit
import  MobileCoreServices

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated:true)
    }
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBAction func uploadBtnClicked(_ sender: UIButton) {
        if allFieldsOk(){
            let uid = UserDefaults.standard.object(forKey: "currentUser") as! String
            let myManager = FirebaseManager()
            let myStorageManager = StorageManager()
            let myImage = profileImageView.image ?? UIImage(named: "PurpleLeaves")
            let myImageData = myImage?.jpegData(compressionQuality: 1)
            
            myStorageManager.uploadProfileImage(userID: uid, data: myImageData!) { (success, url) in
                if success{
                    let myProfile = Profile(name: self.fullnameTextField.text!, email: self.emailTextField.text!, birthday: self.birthdayTextField.text!, pic: url!, key: uid)
                    
                    myManager.uploadProfile(userId: uid, dict: myProfile.getDict())
                    DispatchQueue.main.async {
                        showAlert(viewController: self, "Updated the profile...")
                        //self.presentingViewController?.dismiss(animated: true, completion: nil)
                        
                        }
                    
                }else {
                    print("error adding user to database")
                }
            }
        }
    }
    
    func allFieldsOk()-> Bool{
        let haveText = fullnameTextField.hasText && emailTextField.hasText && birthdayTextField.hasText
        return haveText
    }
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullnameTextField.delegate = self
        emailTextField.delegate = self
        birthdayTextField.delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
        // Do any additional setup after loading the view.
    }
    @objc func dateValueChanged(picker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        birthdayTextField.text = dateFormatter.string(from: picker.date)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage{
            profileImageView.image = image
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
