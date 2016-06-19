//
//  CommentModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/23.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation

class CommentBean: DataBean {
    
    // MARK: - Properties
    var user: UserBean    // 评论者
    var content: String   // 评论内容
    var postID: String
    var time: NSDate?       // 评论时间 TODO:需要加个get和set函数
    
    // MARK: - Init
    override init() {
        user = UserBean()
        content = ""
        postID = ""
        time = NSDate()
    }
    
    // For remote
    init(user: UserBean, content: String, postID:String, time: String) {
        self.user = user
        self.content = content
        self.postID = postID
        
        // TODO: format date
        self.time = NSDate()
    }
    
    // For new
    init(user: UserBean, content: String, postID: String) {
        self.user = user
        self.content = content
        self.postID = postID
        
        time = NSDate()
    }
}