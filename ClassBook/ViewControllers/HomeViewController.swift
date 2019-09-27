//
//  HomeViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var posts: [Post] = []{didSet{
        postsTableView.reloadData()
        }
    }
    
    var currentProfile: Profile?
    
    
    @IBOutlet weak var postsTableView: UITableView!
 
  
   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func signOutBtnClicked(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(nil, forKey: "currentProfile")
        let homeVC =  self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        //loadData()
        if self.searchTextField.hasText{
            self.searchPosts(for: self.searchTextField.text!)
        }else{
            loadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        userButton.layer.cornerRadius = 5
        userImageView.layer.cornerRadius = 15
        
        //Getting the currentProfile from UserDefaults...
        if let savedPerson = UserDefaults.standard.object(forKey: "currentProfile") as? Data
        {
            let decoder = JSONDecoder()
            currentProfile = try? decoder.decode(Profile.self, from: savedPerson)
            if currentProfile != nil{
                print(currentProfile!.name)
                setUserDetailsInView()
            }else{
                //if the currentProfile is not set in UserDefaults
                    let thedate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM YYYY"
                    let mydate = dateFormatter.string(from: thedate)
                    currentProfile = Profile(uid: "1",name: "New User", email: "", birthday: mydate, pic: "")
            }
        }else {
            print("Something went terribly wrong: There is no currentProfile....")
        }
        //End of Getting the currentProfile from UserDefaults...
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
    }
    
    func setUserDetailsInView(){
        userImageView.setImageFromUrl(myUrl: currentProfile!.pic)
        userButton.setTitle(currentProfile!.name, for: .normal)
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
                        
                            var cell :Post
                        cell = Post(postContent: myContent, userID: myAuthor, userName: myUsername, userImageUrl: myUserImage, postImageUrl: myPostImage, timeStamp: myDate, isLiked: myLike, isDeleted: myDelete)
                            //cell = Post(content: myContent, author: myAuthor, pic: myUrl, date: myDate, key: i)
                            self.posts.append(cell)
                        //})
                   
                    }
                }
                self.posts.sort(by: {$1.timeStamp < $0.timeStamp})
                DispatchQueue.main.async {
                   // self.getImagesFromDB()
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }

    func searchPosts(for searchText: String){
        if searchText != ""{
            var tempPosts: [Post] = []
            for post in posts{
                if post.postContent.contains(searchText){
                    tempPosts.append(post)
                }else if post.userName.contains(searchText){
                    tempPosts.append(post)
                }
            }
            posts = tempPosts
            postsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "cell") as! ChatTableViewCell
        let myPost = posts[indexPath.row]
 
        print("Post count\(posts.count)")
        print(myPost)
        
        cell.setValues(post: myPost)
        return cell
    }
}

