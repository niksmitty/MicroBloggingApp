//
//  UserModel.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 17.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import FirebaseDatabase

class UserModel {
    
    var username: String
    var email: String
    var profileImageUrl: String?
    var profileImageGeneration: String?
    
    init(username: String, email: String, profileImageUrl: String?, profileImageGeneration: String?) {
        
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.profileImageGeneration = profileImageGeneration
        
    }
    
    init(snapshot: DataSnapshot) {
        
        let userDict = snapshot.value as! [String: AnyObject]
        
        self.username = userDict["username"] as! String
        self.email = userDict["email"] as! String
        self.profileImageUrl = userDict["profileImageUrl"] as! String?
        self.profileImageGeneration = userDict["profileImageGeneration"] as! String?
        
    }
    
}
