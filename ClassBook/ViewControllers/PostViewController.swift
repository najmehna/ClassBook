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
    var currentProfile: Profile?{didSet{
        currentUser = self.currentProfile?.uid
        }}
    var postImage : UIImage?

    @IBOutlet weak var contentView: UIView!
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
            
            let uid =  currentUser!
            let myTime = String(Int(Date().timeIntervalSinceReferenceDate))
            let postId = myTime + uid
            let myManager = FirebaseManager()
            let myStorageManager = StorageManager()
            let myImageData = postImage?.jpegData(compressionQuality: 1)
            
            myStorageManager.uploadPostImage(postID: postId, data: myImageData!){ (success, url) in
                if success{
                    var myPost: Post
                    if self.currentProfile?.uid != ""{
                    myPost = Post(postContent: self.postTextArea.text, userID: self.currentProfile!.uid, userName: self.currentProfile!.name, userImageUrl: self.currentProfile!.pic, postImageUrl: url!, timeStamp: myTime, isLiked: false, isDeleted: false)
                    }else{
                        myPost = Post(postContent: self.postTextArea.text, userID: "", userName: "New User", userImageUrl: "", postImageUrl: url!, timeStamp: myTime, isLiked: false, isDeleted: false)
                    }
                    myManager.uploadPost(postId: postId, dict: myPost.getDict())
                    let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    homeVC.selectedIndex = 0
                    self.present(homeVC, animated: true, completion: nil)
                    //DispatchQueue.main.async {
                        //showAlert(viewController: self, "Posted your story...")
                        //let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                            //self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            
                        //self.present(homeVC, animated: true, completion: nil)
                        //self.presentingViewController?.dismiss(animated: true, completion: nil)
                   // }
                }else {
                    print("error adding user to database")
                }
            }
        }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 15
        profileButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 15
        currentProfile = UserDefaults.standard.object(forKey:"currentProfile") as? Profile
        if currentUser == nil {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM YYYY"
            let mydate = dateFormatter.string(from: date)
            currentProfile = Profile(uid: "", name: "Guest", email: "", birthday: mydate, pic: "")
        } else{
            setUserDetailsInView()
            }
        // Do any additional setup after loading the view.
    }

    func setUserDetailsInView(){
        let myUrl = URL(fileURLWithPath: currentProfile!.pic)
        profileImageView.load(url: myUrl)
        profileButton.setTitle(currentProfile!.name, for: .normal)
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


//    func setUserDetailsInViewOld(currentUser: String){
//
//        let myManager = FirebaseManager()
//        myManager.getUserData(for: currentUser) { (success, result) in
//            if success{
//                print(result)
//                // self.profiles = []
//                    let values = result.count
//                    if values > 0{
//                        self.currentProfile = Profile(uid: result["uid"] as! String, name: result["name"] as! String, email: result["email"] as! String, birthday: result["birthday"] as! String, pic: result["url"] as! String)
////                        currentProfile = Profile(name: result["name"] as! String, email: result["email"] as! String, birthday: result["birthday"] as! String, pic: result["url"] as! String)
//                        let myName = result["name"] as! String
//                        let myUrl = URL(fileURLWithPath: result["url"] as! String)
//                        DispatchQueue.main.async {
//                            self.profileButton.setTitle(myName, for: .normal)
//                            self.profileImageView.load(url: myUrl)
//                        }
////                        let myStorage = StorageManager()
////                        myStorage.downloadImage(imageName: myUrl) { (success, data) in
////                            DispatchQueue.main.async {
////                                self.profileImageView.image = success ? UIImage(data: data!, scale: 0.5) : UIImage(named: defaultImage)
////                            }
////                        }
//
//                }
//            }
//        }
//    }
