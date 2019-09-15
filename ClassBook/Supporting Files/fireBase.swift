//
//  fireBase.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseManager {
    var ref : DatabaseReference! = Database.database().reference()
    
    func uploadProfile(userId: String, dict : [String:Any]){
        ref.child("profiles").child(userId).setValue(dict)
    }
}
