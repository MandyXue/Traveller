//
//  CommentModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/23.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation

class CommentBean: NSObject {
    
    // MARK: - Properties
    var user: UserBean    // 评论者
    var comment: String?   // 评论内容
    var time: NSDate       // 评论时间
    
    // MARK: - Init
    override init() {
        user = UserBean()
        comment = ""
        time = NSDate()
    }
    
    init(user: UserBean, comment: String, time: NSDate) {
        self.user = user
        self.comment = comment
        self.time = time
    }
}