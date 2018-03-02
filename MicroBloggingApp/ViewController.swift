//
//  ViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 28.02.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuthUI
import FirebasePhoneAuthUI
import FirebaseGoogleAuthUI

//import GoogleSignIn

class ViewController: UIViewController, FUIAuthDelegate {

    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth?
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! Auth.auth().signOut()
        
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIPhoneAuth(authUI: self.authUI!),FUIGoogleAuth(),]
        
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                self.loginAction(sender: self)
                return
            }
        }
    }

    /*func firebaseLogin(_ credential: AuthCredential) {
        showSpinner {
            if let user = Auth.auth().currentUser {
                user.link(with: credential) { (user, error) in
                    self.hideSpinner {
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                    }
                }
            } else {
                Auth.auth().signIn(with: credential) { (user, error) in
                    self.hideSpinner {
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                    }
                }
            }
        }
    }*/
    
}

extension ViewController {
    @IBAction func loginAction(sender: AnyObject) {
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in")
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)")
        }
    }
}

