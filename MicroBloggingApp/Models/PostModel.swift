//
//  PostModel.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import FirebaseDatabase

class PostModel {
    
    var id: String
    var text: String?
    var authorId: String?
    var authorName: String?
    var timestamp: Double?
    
    init(id: String, text: String?, authorId: String?, authorName: String?, timestamp: Double?) {
        
        self.id = id
        self.text = text
        self.authorId = authorId
        self.authorName = authorName
        self.timestamp = timestamp
        
    }
    
    init(snapshot: DataSnapshot) {
        
        let postDict = snapshot.value as! [String: AnyObject]
        
        self.id = snapshot.key
        self.text = postDict["postText"] as! String?
        self.authorId = postDict["postAuthorId"] as! String?
        self.authorName = postDict["postAuthorName"] as! String?
        self.timestamp = postDict["postDate"] as! Double?
        
    }
    
}
