//
//  DatabaseManager.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 02.07.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    private static var sharedDatabaseManager: DatabaseManager = {
        let databaseManager = DatabaseManager(databaseReference: Database.database().reference().child("posts"))
        
        return databaseManager
    }()
    
    let databaseReference: DatabaseReference
    
    private init(databaseReference: DatabaseReference) {
        self.databaseReference = databaseReference
    }
    
    class func shared() -> DatabaseManager {
        return sharedDatabaseManager
    }
    
    func fetchPostsFromFirebase(completion: @escaping (Array<PostModel>?)->()) {
        self.databaseReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                var result = [PostModel]()
                
                for posts in snapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = posts.value as? [String: AnyObject]
                    let postId = posts.key
                    let postText = postObject?["postText"]
                    let postAuthor = postObject?["postAuthor"]
                    
                    let post = PostModel(id: postId as String, text: postText as! String?, author: postAuthor as! String?)
                    
                    result.append(post)
                }
                
                completion(result)
            }
        }
    }
    
    func insertNewPostToFirebase(author: String?, text: String?) {
        self.databaseReference.childByAutoId().setValue(["postAuthor": author, "postText": text])
    }
    
    func deletePostFromFirebase(postId: String) {
        self.databaseReference.child(postId).removeValue()
    }
    
}
