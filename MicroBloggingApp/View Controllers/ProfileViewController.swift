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
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.contentMode = .scaleAspectFill
        
        progressView = M13ProgressViewPie.init(frame: profilePhotoImageView.frame)
        progressView.primaryColor = UIColor.black
        progressView.secondaryColor = UIColor.black
        progressView.backgroundRingWidth = 0.0
        progressView.setProgress(0, animated: true)
        self.view.addSubview(progressView)
        
        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        imagePicker.delegate = self
        
        usernameValueLabel.text = currentUser.displayName
        emailValueLabel.text = currentUser.email
        
        StorageManager.shared().downloadProfileImage(userId: currentUser.uid) { (downloadTask, profileImage) in
            
            if let profileImage = profileImage {
                self.profilePhotoImageView.image = profileImage
            } else {
                self.profilePhotoImageView.image = UIImage.init(named: "unknownUser")
            }

            guard let downloadTask = downloadTask else { return }
            
            StorageManager.shared().observe(task: downloadTask, status: .success, completion: { snapshot in
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
        
        progressView.isHidden = false
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        profilePhotoImageView.image = pickedImage
        
        guard let currentUser = AuthenticationManager.shared().currentUser() else { return }
        
        StorageManager.shared().uploadProfileImage(image: pickedImage, userId: currentUser.uid) { (uploadTask) in
            StorageManager.shared().observe(task: uploadTask, status: .success, completion: { snapshot in
                let profileImageUrl = snapshot.metadata?.downloadURL()?.absoluteString
                
                let userInfo = ["profileImageUrl": profileImageUrl!]
                DatabaseManager.shared().updateUserInfo(uid: currentUser.uid, userInfo: userInfo)
                
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
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension M13ProgressViewPie {
    
    func performEndAction(action: M13ProgressViewAction, withDelay: Double) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.animationDuration) + 0.1, execute: {
            self.perform(action, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
                self.perform(M13ProgressViewActionNone, animated: true)
                self.setProgress(0, animated: true)
                self.isHidden = true
            }
        })
        
    }
    
}
