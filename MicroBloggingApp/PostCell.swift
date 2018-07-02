//
//  PostCell.swift
//  MicroBloggingApp
//
//  Created by Nikita Votyakov on 27.03.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postTextLabel.lineBreakMode = .byWordWrapping
        postTextLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
