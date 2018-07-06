//
//  ProfileViewController.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 05.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var aboutValueLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        profilePhotoImageView.clipsToBounds = true
        profilePhotoImageView.contentMode = .scaleAspectFill
        
        let testImageRef = storageRef.child("images/testImage.jpg")
        
        testImageRef.getData(maxSize: 30*1024*1024) { data, error in
            if error != nil {
                self.profilePhotoImageView.image = UIImage.init(named: "unknownUser")
            } else {
                let image = UIImage(data: data!)
                self.profilePhotoImageView.image = image
            }
        }
        
        imagePicker.delegate = self
        
        usernameValueLabel.text = Auth.auth().currentUser?.displayName
        emailValueLabel.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePhotoImageView.image = pickedImage
        }
        
        let data = UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage)! as NSData

        let imagesRef = storageRef.child("images")
        let testImageRef = imagesRef.child("testImage.jpg")
        let uploadTask = testImageRef.putData(data as Data, metadata: nil) { metadata, error in
            guard let metadata = metadata else { return }
            let size = metadata.size
            self.storageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else { return }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
