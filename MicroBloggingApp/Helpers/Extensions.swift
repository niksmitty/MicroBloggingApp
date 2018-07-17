//
//  Extensions.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 16.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import M13ProgressSuite

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
        
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
