//
//  UserPostTableViewCell.swift
//  Traveller
//
//  Created by MandyXue on 16/5/30.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
