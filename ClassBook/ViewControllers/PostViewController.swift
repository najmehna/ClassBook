//
//  PostViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit
import MobileCoreServices

class PostViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    var currentUser : Profile?
    var postImage : UIImage?
    @IBOutlet weak var postTextArea: UITextView!
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated:true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: UIButton) {
        if allFieldsOk(){
            let storageManager = StorageManager()
            //storageManager.uploadPostImage(userID: <#T##String#>, postKey: <#T##String#>, data: <#T##Data#>)
        }
    }
    @IBOutlet weak var postImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserDefaults.standard.object(forKey: "currentUser") as? Profile
        if currentUser != nil{
            print(currentUser!.birthday)
        }else {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM YYYY"
            let mydate = dateFormatter.string(from: date)
            currentUser = Profile(name: "New User", email: "", birthday: mydate, pic: "", key: "1")
        }
        // Do any additional setup after loading the view.
    }
    
    func allFieldsOk()-> Bool{
        
        postImage = postImage ?? postImageView.image
        
        return postTextArea.hasText
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage{
            postImage = image
            postImageView.image = postImage
        }
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
