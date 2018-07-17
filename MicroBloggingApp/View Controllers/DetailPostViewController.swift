//
//  DetailPostViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 12.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import SDWebImage

class DetailPostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postDateAndTimeLabel: UILabel!
    @IBOutlet weak var postAuthorProfileImageView: UIImageView!
    @IBOutlet weak var postAuthorUsernameLabel: UILabel!
    
    var postText, postAuthorId, postAuthorName, postDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextView.text = postText
        postAuthorUsernameLabel.text = postAuthorName
        postDateAndTimeLabel.text = postDate
        
        postAuthorProfileImageView.layer.cornerRadius = postAuthorProfileImageView.frame.size.width / 2
        postAuthorProfileImageView.clipsToBounds = true
        postAuthorProfileImageView.contentMode = .scaleAspectFill
        
        DatabaseManager.shared().getUserInfoFromFirebase(uid: postAuthorId!) { (userInfo) in
            let profileImageUrl = userInfo?["profileImageUrl"] as? String ?? ""
            self.postAuthorProfileImageView.sd_setShowActivityIndicatorView(true)
            self.postAuthorProfileImageView.sd_setIndicatorStyle(.gray)
            self.postAuthorProfileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "unknown"))
        }
        
        navigationItem.title = "Post Info"
    }
    
}
