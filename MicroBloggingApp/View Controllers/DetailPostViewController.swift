//
//  DetailPostViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 12.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation

class DetailPostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postDateAndTimeLabel: UILabel!
    @IBOutlet weak var postAuthorProfileImageView: UIImageView!
    @IBOutlet weak var postAuthorUsernameLabel: UILabel!
    
    var postText, postAuthor, postDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.text = postText
        postAuthorUsernameLabel.text = postAuthor
        postDateAndTimeLabel.text = postDate
        
        navigationItem.title = "Post Info"
    }
    
}
