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
    
    // MARK: Work with posts
    
    func fetchPostsFromFirebase(completion: @escaping (Array<PostModel>?)->()) {
        postsReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                var result = [PostModel]()
                
                for postObject in snapshot.children.allObjects as! [DataSnapshot] {

                    let post = PostModel(snapshot: postObject)
                    result.insert(post, at: 0)
                    
                }
                
                completion(result)
            }
        }
    }
    
    func getPostsOfUser(with uid: String, completion: @escaping ([PostModel]?)->()) {
        postsReference.queryOrdered(byChild: "postAuthorId").queryEqual(toValue: uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.childrenCount > 0 {
                
                var result = [PostModel]()
                
                for postObject in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let post = PostModel(snapshot: postObject)
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
    
    // MARK: Work with users
    
    func getUserInfoFromFirebase(uid: String, completion: @escaping (UserModel)->()) {
        usersReference.child(uid).observeSingleEvent(of: .value) { snapshot in
            let user = UserModel(snapshot: snapshot)
            completion(user)
        }
    }
    
    func insertNewUserToFirebase(uid: String, userInfo: Dictionary<String, String>) {
        usersReference.child(uid).setValue(userInfo)
    }
    
    func updateUserInfo(uid: String, userInfo: Dictionary<String, String>) {
        usersReference.child(uid).updateChildValues(userInfo)
    }
    
}
