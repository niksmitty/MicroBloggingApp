//
//  ProfileViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 05.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import M13ProgressSuite

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var aboutValueLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var progressView = M13ProgressViewPie()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.contentMode = .scaleAspectFill
        
        progressView = M13ProgressViewPie.init(frame: profilePhotoImageView.frame)
        progressView.primaryColor = UIColor.black
        progressView.secondaryColor = UIColor.black
        progressView.backgroundRingWidth = 0.0
        progressView.isHidden = true
        progressView.setProgress(0, animated: true)
        self.view.addSubview(progressView)
        
        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        imagePicker.delegate = self
        
        usernameValueLabel.text = currentUser.displayName
        emailValueLabel.text = currentUser.email
        
        var isLocalProfileImageExist = true
        
        StorageManager.shared().setProfileImageLocaUrl(with: currentUser.uid)
        
        do {
            
            guard let profileImageLocalUrl = StorageManager.shared().profileImageLocalUrl else { return }
            let imageData = try Data(contentsOf: profileImageLocalUrl)
            self.profilePhotoImageView.image = UIImage(data: imageData)
            
        } catch {
            
            print("Unable to load image: \(error)")
            isLocalProfileImageExist = false
            self.profilePhotoImageView.image = UIImage.init(named: "unknownUser")
            
        }
        
        StorageManager.shared().getProfileImageGeneration(userId: currentUser.uid) { generation in
            
            guard let generation = generation else { return }
            DatabaseManager.shared().getUserInfoFromFirebase(uid: currentUser.uid, completion: { userInfo in
                
                let previousProfileImageGeneration = userInfo.profileImageGeneration ?? ""
                if generation != previousProfileImageGeneration || !isLocalProfileImageExist {
                    self.downloadImage(forUser: currentUser.uid, withGeneration: generation)
                }
                
            })
            
        }
        
    }
    
    // MARK: Uploading/Downloading methods
    
    private func uploadImage(forUser userId:String, withImage image: UIImage) {
        
        progressView.isHidden = false
        
        StorageManager.shared().uploadProfileImage(image: image, userId: userId) { uploadTask in
            
            StorageManager.shared().observe(task: uploadTask, status: .success, completion: { snapshot in
                
                let profileImageUrl = snapshot.metadata?.downloadURL()?.absoluteString
                
                let userInfo = ["profileImageUrl": profileImageUrl!]
                DatabaseManager.shared().updateUserInfo(uid: userId, userInfo: userInfo)
                
                self.progressView.performEndAction(action: M13ProgressViewActionSuccess, withDelay: 1.5)
                
            })
            
            StorageManager.shared().observe(task: uploadTask, status: .progress, completion: { snapshot in
                
                let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                if !percentComplete.isNaN {
                    self.progressView.setProgress(CGFloat(percentComplete), animated: true)
                }
                
            })
            
            StorageManager.shared().observe(task: uploadTask, status: .failure, completion: { snapshot in
                
                self.progressView.performEndAction(action: M13ProgressViewActionFailure, withDelay: 1.5)
                
            })
            
        }
        
    }
    
    private func downloadImage(forUser userId:String, withGeneration generation: String) {
        
        progressView.isHidden = false
        
        StorageManager.shared().downloadProfileImage(userId: userId) { downloadTask in
            
            StorageManager.shared().observe(task: downloadTask, status: .success, completion: { snapshot in
                
                do {
                    
                    guard let profileImageLocalUrl = StorageManager.shared().profileImageLocalUrl else { return }
                    let imageData = try Data(contentsOf: profileImageLocalUrl)
                    self.profilePhotoImageView.image = UIImage(data: imageData)
                    
                } catch {
                    
                    print("Unable to load image: \(error)")
                    self.profilePhotoImageView.image = UIImage.init(named: "unknownUser")
                    
                }
                
                let userInfo = ["profileImageGeneration": generation]
                DatabaseManager.shared().updateUserInfo(uid: userId, userInfo: userInfo)
                
                self.progressView.performEndAction(action: M13ProgressViewActionSuccess, withDelay: 1.5)
                
            })
            
            StorageManager.shared().observe(task: downloadTask, status: .progress, completion: { snapshot in
                let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                if !percentComplete.isNaN {
                    self.progressView.setProgress(CGFloat(percentComplete), animated: true)
                }
            })
            
            StorageManager.shared().observe(task: downloadTask, status: .failure, completion: { snapshot in
                self.progressView.performEndAction(action: M13ProgressViewActionFailure, withDelay: 1.5)
            })
            
        }
        
    }
    
    // MARK: Button Actions
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        profilePhotoImageView.image = pickedImage
        
        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        StorageManager.shared().getProfileImageGeneration(userId: currentUser.uid) { generation in
            guard let generation = generation else { return }
            let userInfo = ["profileImageGeneration": generation]
            DatabaseManager.shared().updateUserInfo(uid: currentUser.uid, userInfo: userInfo)
        }
        
        uploadImage(forUser: currentUser.uid, withImage: pickedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
