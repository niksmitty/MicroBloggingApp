//
//  AuthenticationManager.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 05.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager {
    
    private static var sharedAuthManager: AuthenticationManager = {
        let authManager = AuthenticationManager()
 
        return authManager
    }()
    
    var authStateListenerHandle : AuthStateDidChangeListenerHandle?
    
    private init() {
    }
    
    class func shared() -> AuthenticationManager {
        return sharedAuthManager
    }
    
    func addStateDidChangeListener(completion: @escaping AuthStateDidChangeListenerBlock) {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            completion(auth, user)
        }
    }
    
    func removeStateDidChangeListener() {
        Auth.auth().removeStateDidChangeListener(authStateListenerHandle!)
    }
    
    func isCurrentUserExist() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signIn(withEmail: String, password: String, completion: @escaping AuthResultCallback) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(user, error)
        }
    }
    
    func signUp(withEmail: String, password: String, username: String, photoURLString: String, completion: @escaping AuthResultCallback) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.photoURL = URL(string: photoURLString)
                changeRequest?.commitChanges { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                completion(user, error)
            }
        }
    }
    
}
