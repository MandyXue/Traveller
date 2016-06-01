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
    var username: String?       // 用户名
    var avatar: UIImage?        // 用户头像
    var place: String?          // 用户所在地区
    var posts: [PostModel] = [] // 用户发表的post
    var gender: Bool            // 用户性别，true为男，false为女
    var summary: String?        // 用户简介
    var email: String?          // 邮箱
    var homepage: String?       // 主页or博客
    var registerDate: NSDate?   // 注册时间
    
    // MARK: - Init
    override init() {
        username = ""
        place = ""
        gender = true
        summary = ""
        email = ""
        homepage = ""
        registerDate = NSDate(timeIntervalSinceNow: 0)
    }
    
    init(username: String, avatar: UIImage, place: String) {
        self.username = username
        self.avatar = avatar
        self.place = place
        gender = true
        summary = nil
        email = nil
        homepage = nil
        registerDate = NSDate(timeIntervalSinceNow: 0)
    }
    
    init(username: String, avatar: UIImage, place: String, gender: Bool, summary: String, email: String, homepage: String, registerDate: NSDate?) {
        self.username = username
        self.avatar = avatar
        self.place = place
        self.gender = gender
        self.summary = summary
        self.email = email
        self.homepage = homepage
        if registerDate == nil {
            self.registerDate = NSDate(timeIntervalSinceNow: 0)
        } else {
            self.registerDate = registerDate
        }
    }
    
}