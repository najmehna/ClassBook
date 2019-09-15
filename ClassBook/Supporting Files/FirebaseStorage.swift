//
//  FirebaseStorage.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation
import Firebase

class StorageManager {
    let ref = Storage.storage().reference()
    
    func uploadProfileImage(userID: String, data:Data, completionBlock: @escaping (_ success:Bool,_ url:String?)->Void){
        let imageName = userID.hasSuffix(".jpg") ? userID : userID + ".jpg"
        let myRef = ref.child("images").child("profilePics/\(imageName)")
        //let uplaodTask =
        myRef.putData(data, metadata: nil) { (metaData, error) in
            if error == nil{
                guard let metaData = metaData else{
                    return
                }
                let size = metaData.size
                let url = metaData.path
                completionBlock(true, url)
                print("The size is: \(size) and the type is: \(url.debugDescription)")
            }else {
                completionBlock(false, nil)
            }
        }
    }
    func uploadPostImage(userID: String,postKey: String, data:Data){
        let imageName = userID.hasSuffix(".jpg") ? userID : userID + ".jpg"
        let myRef = ref.child("images").child("posts/\(postKey)/\(imageName)")
        //let uplaodTask =
        myRef.putData(data, metadata: nil) { (metaData, error) in
            if error == nil{
                guard let metaData = metaData else{
                    return
                }
                let size = metaData.size
                let contnt = metaData.contentType
                print("The size is: \(size) and the type is: \(contnt.debugDescription)")
            }
        }
    }
    
    func downloadProfileImage(imageName: String, completionBlock: @escaping (Bool,Data?)->Void){
        let myRef = ref.child("images").child("profilePics/\(imageName)")
        myRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            if error == nil{
                completionBlock(true, data!)
            } else {
                print(error!.localizedDescription + "      WHAAAAAATTTT    " + error.debugDescription)
                completionBlock(false, nil)
            }
        }
    }
}
