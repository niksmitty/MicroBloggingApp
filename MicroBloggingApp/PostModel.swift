//
//  PostModel.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit

class PostModel {
    var id: String?
    var text: String?
    var author: String?
    
    init(id: String?, text: String?, author: String?) {
        self.id = id
        self.text = text
        self.author = author
    }
}
