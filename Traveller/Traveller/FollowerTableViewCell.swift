//
//  FollowerTableViewCell.swift
//  Traveller
//
//  Created by MandyXue on 16/6/6.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class FollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.setTitle("Follow", forState: .Normal)
        addButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        addButton.setTitleColor(UIColor(red: 1, green: 170/255, blue: 0, alpha: 1), forState: .Normal)
        addButton.titleEdgeInsets = UIEdgeInsetsMake(30, (addButton.titleLabel?.bounds.size.width)!-30, 0, 0)
        // TODO: 根据用户follow没follow改变button图片和字体与颜色
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
