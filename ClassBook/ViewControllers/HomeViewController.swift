//
//  HomeViewController.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var posts: [Post] = []
    var pics: [Data] = []
    
  

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let myManager = FirebaseManager()
        myManager.getPosts { (success, postDict) in
            if success{
                var cell :Post
                self.posts = []
                for i in postDict.keys{
                    if let values = postDict[i] as? Dictionary<String, Any>{
                        let myContent = values["postContent"] as! String
                        let myAuthor = values["author"] as! String
                        let myUrl = values["url"] as! String
                        let myDate = values["date"] as! String
                        cell = Post(content: myContent, author: myAuthor, pic: myUrl, date: myDate, key: i)
                        self.posts.append(cell)
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
            let url = posts[post].pic
            storageManager.downloadImage(imageName: url) { (success, data) in
                let myImageData = success ? data! : UIImage(named: "purpleLeaves")!.jpegData(compressionQuality: 1.0)!
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
        myPic = UIImage(named: "purpleLeaves")!.jpegData(compressionQuality: 1.0)!
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
