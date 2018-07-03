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
        navigationItem.title = "Feed"
        
        DatabaseManager.shared().fetchPostsFromFirebase { (result) in
            self.postsList.removeAll()
            self.postsList += result ?? []
            self.tableView.reloadData()
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
    
    // MARK: UITableViewDataSource
    
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            DatabaseManager.shared().deletePostFromFirebase(postId: postsList[indexPath.row].id)
            postsList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.tableView.setEditing(false, animated: true)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = postsList[indexPath.row]
        print((post.author ?? "") + " says: " + (post.text ?? ""))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
