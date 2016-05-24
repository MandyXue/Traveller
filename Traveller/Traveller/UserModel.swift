//
//  UserModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/23.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UserModel: NSObject {
    
    // MARK: - Properties
    var username: String?   // 用户名
    var avatar: UIImage?  // 用户头像
    var place: String?      // 用户所在地区
    
    // MARK: - Init
    override init() {
        username = ""
        place = ""
    }
    
    init(username: String, avatar: UIImage, place: String) {
        self.username = username
        self.avatar = avatar
        self.place = place
    }
    
}