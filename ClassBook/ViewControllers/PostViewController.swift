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
   
    //var currentUser : Profile?
    var currentUser: String?
    var currentProfile: Profile?
    var postImage : UIImage?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var postTextArea: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
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
           // let storageManager = StorageManager()
            //storageManager.uploadPostImage(userID: <#T##String#>, postKey: <#T##String#>, data: <#T##Data#>)
            
            let uid = UserDefaults.standard.object(forKey: "currentUser") as! String
            let myTime = String(Int(Date().timeIntervalSinceReferenceDate))
            let postId = uid + myTime
            let myManager = FirebaseManager()
            let myStorageManager = StorageManager()
            let myImageData = postImage?.jpegData(compressionQuality: 1)
            
            myStorageManager.uploadPostImage(postID: postId, data: myImageData!){ (success, url) in
                if success{
                    let myPost = Post(content: self.postTextArea.text, author: uid, pic: url!, date: myTime, key: postId)
                    
                    myManager.uploadPost(postId: postId, dict: myPost.getDict())
                    DispatchQueue.main.async {
                        showAlert(viewController: self, "Posted your story...")
                        //self.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }else {
                    print("error adding user to database")
                }
            }
        }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserDefaults.standard.string(forKey: "currentUser")
        if currentUser == nil {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM YYYY"
            let mydate = dateFormatter.string(from: date)
           // currentUser = Profile(name: "New User", email: "", birthday: mydate, pic: "", key: "1")
        } else{
            setUserDetailsInView(currentUser: currentUser!)
            }
        
        // Do any additional setup after loading the view.
    }

    func setUserDetailsInView(currentUser: String){
      
        let myManager = FirebaseManager()
        myManager.getUserData(for: currentUser) { (success, result) in
            if success{
                print(result)
                // self.profiles = []
                    let values = result.count
                    if values > 0{
                        let myName = result["name"] as! String
                        let myUrl = result["url"] as! String
                        DispatchQueue.main.async {
                            self.profileButton.setTitle(myName, for: .normal)
                        }
                        let myStorage = StorageManager()
                        myStorage.downloadImage(imageName: myUrl) { (success, data) in
                            DispatchQueue.main.async {
                                self.profileImageView.image = success ? UIImage(data: data!, scale: 0.5) : UIImage(named: "purpleLeaves")
                            }
                        }
                    
                }
            }
        }
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
