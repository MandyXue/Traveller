//
//  SpotTableViewCell.swift
//  Traveller
//
//  Created by MandyXue on 16/6/13.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upLineView: UIImageView!
    @IBOutlet weak var bottomLineView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
