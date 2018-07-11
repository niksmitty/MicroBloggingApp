//
//  StorageManager.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 11.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation
import Firebase

class StorageManager {
    
    private var PROFILE_IMAGES_URL = "profileImages"
    
    private static var sharedStorageManager: StorageManager = {
        
        let storageManager = StorageManager(storageReference: Storage.storage().reference())
        
        return storageManager
        
    }()
    
    let storageReference, profileImagesReference: StorageReference
    
    private init(storageReference: StorageReference) {
        
        self.storageReference = storageReference
        self.profileImagesReference = storageReference.child(PROFILE_IMAGES_URL)
        
    }
    
    class func shared() -> StorageManager {
        
        return sharedStorageManager
        
    }
    
    func uploadProfileImage(image: UIImage, userId: String, completion: (StorageUploadTask)->()) {
        
        let data = UIImagePNGRepresentation(image)!
        
        let profileImageRef = profileImagesReference.child("\(userId).png")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let uploadTask = profileImageRef.putData(data, metadata: metadata)
        completion(uploadTask)
        
    }
    
    func downloadProfileImage(userId: String, completion: @escaping (StorageDownloadTask?, UIImage?)->()) {
        
        let profileImageRef = profileImagesReference.child("\(userId).png")
        
        let localURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/profileImage.png")
        
        var profileImage : UIImage?
        
        let downloadTask = profileImageRef.write(toFile: localURL) { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                profileImage = nil
            } else {
                if let url = url {
                    do {
                        let imageData = try Data(contentsOf: url)
                        profileImage = UIImage(data: imageData)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
            }
            completion(nil, profileImage)
        }
        
        completion(downloadTask, nil)
        
    }
    
    func observe(task: StorageObservableTask, status: StorageTaskStatus, completion: @escaping (StorageTaskSnapshot)->()) {
        
        task.observe(status) { (snapshot) in
            
            switch status {
            case .failure:
                self.handleFailure(snapshot: snapshot)
                break
            default:
                break
            }
            
            completion(snapshot)
            
        }
        
    }
    
    func handleFailure(snapshot: StorageTaskSnapshot) {
        
        guard let errorCode = (snapshot.error as NSError?)?.code else { return }
        guard let error = StorageErrorCode(rawValue: errorCode) else { return }
        switch (error) {
        case .objectNotFound:
            print("File doesn't exist")
            break
        case .unauthorized:
            print("User doesn't have permission to access file")
            break
        case .cancelled:
            print("User cancelled the download")
            break
        case .unknown:
            print("Unknown error occurred, inspect the server response")
            break
        default:
            print("Another error occurred. This is a good place to retry the download.")
            break
        }
        
    }
    
}
