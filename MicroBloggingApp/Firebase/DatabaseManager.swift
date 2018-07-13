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
    
    private var POSTS_URL = "posts"
    private var USERS_URL = "users"
    
    private static var sharedDatabaseManager: DatabaseManager = {
        let databaseManager = DatabaseManager(databaseReference: Database.database().reference())
        
        return databaseManager
    }()
    
    let databaseReference, postsReference, usersReference: DatabaseReference
    
    private init(databaseReference: DatabaseReference) {
        self.databaseReference = databaseReference
        self.postsReference = databaseReference.child(POSTS_URL)
        self.usersReference = databaseReference.child(USERS_URL)
    }
    
    class func shared() -> DatabaseManager {
        return sharedDatabaseManager
    }
    
    func fetchPostsFromFirebase(completion: @escaping (Array<PostModel>?)->()) {
        postsReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                var result = [PostModel]()
                
                for posts in snapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = posts.value as? [String: AnyObject]
                    let postId = posts.key
                    let postText = postObject?["postText"]
                    let postAuthorId = postObject?["postAuthorId"]
                    let postAuthorName = postObject?["postAuthorName"]
                    let postDate = postObject?["postDate"]
                    
                    let post = PostModel(id: postId as String, text: postText as! String?, authorId: postAuthorId as! String?, authorName: postAuthorName as! String?, timestamp: postDate as! Double?)
                    
                    result.insert(post, at: 0)
                }
                
                completion(result)
            }
        }
    }
    
    func insertNewPostToFirebase(postInfo:Dictionary<String, Any>) {
        postsReference.childByAutoId().setValue(postInfo)
    }
    
    func deletePostFromFirebase(postId: String) {
        postsReference.child(postId).removeValue()
    }
    
    func getUserInfoFromFirebase(uid: String, completion: @escaping (Dictionary<String, AnyObject>?)->()) {
        usersReference.child(uid).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? [String: AnyObject]
            completion(value)
        }
    }
    
    func insertNewUserToFirebase(uid: String, userInfo: Dictionary<String, String>) {
        usersReference.child(uid).setValue(userInfo)
    }
    
    func updateUserInfo(uid: String, userInfo: Dictionary<String, String>) {
        usersReference.child(uid).updateChildValues(userInfo)
    }
    
}
