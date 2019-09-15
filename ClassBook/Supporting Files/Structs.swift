//
//  Structs.swift
//  ClassBook
//
//  Created by najmeh nasiriyani on 2019-09-14.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation

struct Profile{
    var name: String
    var email: String
    var birthday : String
    var pic: String
    var key: String
    //var image: UIImage
    func getKey() -> String{
        return key
    }
    func getDict()-> [String:Any]{
        let myDict: [String:Any] = ["name":self.name, "email":self.email, "birthday" : self.birthday, "url" : self.pic]
        return myDict
    }
  
}
