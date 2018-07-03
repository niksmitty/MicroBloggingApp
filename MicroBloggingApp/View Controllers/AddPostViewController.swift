//
//  AddPostViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(uploadPostAction))
        navigationItem.title = "Add Post"
    }
    
    @IBAction func uploadPostAction(_ sender: Any?) {
        DatabaseManager.shared().insertNewPostToFirebase(author: authorTextField.text, text: postTextView.text)
        navigationController?.popViewController(animated: true)
    }
    
}
