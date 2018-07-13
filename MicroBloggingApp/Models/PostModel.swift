//
//  PostModel.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit

class PostModel {
    var id: String
    var text: String?
    var authorId: String?
    var authorName: String?
    var timestamp: Double?
    
    init(id: String, text: String?, authorId: String?, authorName: String?, timestamp: Double?) {
        self.id = id
        self.text = text
        self.authorId = authorId
        self.authorName = authorName
        self.timestamp = timestamp
    }
}
