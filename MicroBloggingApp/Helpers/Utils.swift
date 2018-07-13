//
//  Utils.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 13.07.2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import Foundation

class Utils {
    
    class func getFormattedDateString(from timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("en_US_POSIX")
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
}
