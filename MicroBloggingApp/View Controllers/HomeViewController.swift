//
//  HomeViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 17.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var transparentButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "PostCell"
    
    var userPostsList = [PostModel]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.title = "Home"
        
        transparentButton.setBackgroundColor(color: UIColor.init(hexString: "#d9d9d9"), forState: .highlighted)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        usernameLabel.text = currentUser.displayName
        
        DatabaseManager.shared().getPostsOfUser(with: currentUser.uid) { result in
            self.userPostsList.removeAll()
            self.userPostsList += result ?? []
            self.tableView.reloadData()
        }
        
        DatabaseManager.shared().getUserInfoFromFirebase(uid: currentUser.uid) { userInfo in
            let profileImageUrl = userInfo.profileImageUrl ?? ""
            self.profileImageView.sd_setShowActivityIndicatorView(true)
            self.profileImageView.sd_setIndicatorStyle(.gray)
            self.profileImageView.sd_setImage(with: URL(string: profileImageUrl), placeholderImage: UIImage(named: "unknown"))
        }
    }
    
    @IBAction func profileInfoViewTouched(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowProfileInfo", sender: sender)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        let post = userPostsList[indexPath.row]
        
        cell.postTextLabel.text = post.text
        cell.postAuthorLabel.text = post.authorName
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
