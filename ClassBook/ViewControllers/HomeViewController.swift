//
//  HomeViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var posts: [Post] = []{didSet{
        postsTableView.reloadData()
        }
    }
    var pics: [Data] = []{didSet{
        postsTableView.reloadData()
        }
    }
    
    var currentProfile: Profile?{
        didSet{
            currentUser = self.currentProfile?.uid
        }
    }
    var currentUser: String?
    
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        userButton.layer.cornerRadius = 10
        userImageView.layer.cornerRadius = 15
        currentProfile = UserDefaults.standard.object(forKey: "currentProfile") as? Profile
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        // Do any additional setup after loading the view.
        //currentUser = currentProfile?.uid
        
        if currentUser == nil {
//            let thedate = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMM YYYY"
//            let mydate = dateFormatter.string(from: thedate)
            // currentUser = Profile(name: "New User", email: "", birthday: mydate, pic: "", key: "1")
        } else{
            setUserDetailsInView(currentUser: currentUser!)
        }
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
                    let myUrl = URL(fileURLWithPath:result["url"] as! String)
                    DispatchQueue.main.async {
                        self.userButton.setTitle(myName, for: .normal)
                    }
                    self.userImageView.load(url: myUrl)
//                    let myStorage = StorageManager()
//                    myStorage.downloadImage(imageName: myUrl) { (success, data) in
//                        DispatchQueue.main.async {
//                            self.userImageView.image = success ? UIImage(data: data!, scale: 0.5) : UIImage(named: defaultImage)
//                        }
//                    }
             
                }
            }
        }
    }
    
    func loadData(){
        let myManager = FirebaseManager()
        myManager.getPosts { (success, postDict) in
            if success{
                self.posts = []
                for i in postDict.keys{
                    if let values = postDict[i] as? Dictionary<String, Any>{
                        let myContent = values["postContent"] as! String
                        let myAuthor = values["userID"] as! String
                        let myPostImage = values["postImageUrl"] as! String
                        let myDate = values["timeStamp"] as! String
                        let myUsername = values["userName"] as! String
                        let myUserImage = values["userImageUrl"] as! String
                        let myLike = values["isLiked"] as! Bool
                        let myDelete = values["isDeleted"] as! Bool
                        
                        
//                        print(myAuthor)
//                        let myManager2 = FirebaseManager()
//                        myManager2.getUserData(for: myAuthor, completionBlock: { (success, resultDic) in
//                            let values = resultDic.count
//                            let author = values > 0 ? resultDic["name"] as! String : "New User"
                            var cell :Post
                        cell = Post(postContent: myContent, userID: myAuthor, userName: myUsername, userImageUrl: myUserImage, postImageUrl: myPostImage, timeStamp: myDate, isLiked: myLike, isDeleted: myDelete)
                            //cell = Post(content: myContent, author: myAuthor, pic: myUrl, date: myDate, key: i)
                            self.posts.append(cell)
                        //})
                        
                        
                    }
                }
                DispatchQueue.main.async {
                    self.getImagesFromDB()
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    func getImagesFromDB(){
        let storageManager = StorageManager()
        pics = []
        for post in posts.indices{
            let url = posts[post].postImageUrl
            storageManager.downloadImage(imageName: url) { (success, data) in
                let myImageData = success ? data! : UIImage(named: defaultImage)!.jpegData(compressionQuality: 1.0)!
                self.pics.append(myImageData)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "cell") as! ChatTableViewCell
        let myPost = posts[indexPath.row]
        let myPic : Data
        if pics.count > indexPath.row{
            myPic = pics[indexPath.row]
        }else{
        myPic = UIImage(named: defaultImage)!.jpegData(compressionQuality: 1.0)!
        }
        cell.setValues(post: myPost, pic: myPic)
        return cell
        
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
