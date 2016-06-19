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
    var user: UserBean?
    var id: String?
    var creatorId: String
    var creatorAvatarURL: String?
    var content: String   // 评论内容
    var postID: String
    var time: String       // 评论时间
    
    // MARK: - Init
    override init() {
        self.creatorId = ""
        content = ""
        postID = ""
        time = ""
    }
    
    // For remote
    init(commentId id:String, creatorId: String, avatarURL: String?, content: String, postID:String, createDate: String) {
        self.id = id
        self.creatorId = creatorId
        self.creatorAvatarURL = avatarURL
        self.content = content
        self.postID = postID
        self.time = createDate
        
        super.init()
    }
    
    // For new
    init(creatorID: String, content: String, postID: String) {
        self.creatorId = creatorID
        self.content = content
        self.postID = postID
        
        time = DataBean.dateFormatter.stringFromDate(NSDate())
        super.init()
    }
}