//
//  PostCommentTableViewCell.swift
//  Traveller
//
//  Created by MandyXue on 16/5/23.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
