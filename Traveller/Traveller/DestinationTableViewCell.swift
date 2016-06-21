//
//  DestinationTableViewCell.swift
//  Traveller
//
//  Created by MandyXue on 16/6/12.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var destNameLabel: UILabel!
    @IBOutlet weak var destImageView: UIImageView! {
        didSet {
            destImageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var destDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
