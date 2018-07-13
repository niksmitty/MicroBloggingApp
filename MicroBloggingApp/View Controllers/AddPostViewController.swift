//
//  AddPostViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(uploadPostAction))
        navigationItem.title = "Add Post"
        
        postTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        postTextView.layer.borderWidth = 2.0
        postTextView.layer.cornerRadius = 5
        postTextView.clipsToBounds = true
        
        postTextView.becomeFirstResponder()
    }
    
    @IBAction func uploadPostAction(_ sender: Any?) {
        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        let postInfo = [
                        "postAuthorId": currentUser.uid,
                        "postText": postTextView.text!,
                        "postAuthorName": currentUser.displayName!,
                        "postDate": Date().timeIntervalSince1970
                       ] as [String : Any]
        DatabaseManager.shared().insertNewPostToFirebase(postInfo: postInfo)
        navigationController?.popViewController(animated: true)
    }
    
}
