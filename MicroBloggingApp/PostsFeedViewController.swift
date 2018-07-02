//
//  PostsFeedViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 02.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit
import Firebase

class PostsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refPosts: DatabaseReference!
    
    var postsList = [PostModel]()
    let reuseIdentifier = "PostCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(logOutAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostAction))
        
        refPosts = Database.database().reference().child("posts")
        
        fetchPostsFromFirebase()
    }
    
    func fetchPostsFromFirebase() {
        refPosts.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.postsList.removeAll()
                
                for posts in snapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = posts.value as? [String: AnyObject]
                    let postId = posts.key
                    let postText = postObject?["postText"]
                    let postAuthor = postObject?["postAuthor"]
                    
                    let post = PostModel(id: postId as String?, text: postText as! String?, author: postAuthor as! String?)
                    
                    self.postsList.append(post)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: Any?) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBAction func addPostAction(_ sender: Any?) {
        self.performSegue(withIdentifier: "AddPost", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        let post = postsList[indexPath.row]
        
        cell.postTextLabel.text = post.text
        cell.postAuthorLabel.text = post.author
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(postsList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}