//
//  PostModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import MapKit

class PostBean: NSObject {
    
    var pointId: Int = 0
    
    // MARK: - MKAnnotation Property
    
    var place: String?                    // 景点名称
    var address: String?                  // 景点地址
    var detail: String?                   // 景点详细介绍
    var comments: [CommentBean] = []     // 景点的相关评论
    var location: CLLocationCoordinate2D  // 景点的GPS信息
    var images: [UIImage] = []            // 景点的图片
    var creator: UserBean                // 创建者
    
    // MARK: - Init
    
    override init() {
        place = nil
        detail = nil
        address = nil
        location = CLLocationCoordinate2D()
        creator = UserBean()
    }
    
    init(place: String, detail: String, location: CLLocationCoordinate2D, address: String, creator: UserBean) {
        self.place = place
        self.detail = detail
        self.location = location
        self.creator = creator
        self.address = address
    }
    
    // MARK: - Methods
    
    func addImage(image: UIImage) {
        self.images.append(image)
    }
    
    func addComment(comment: CommentBean?) {
        if comment != nil {
            self.comments.append(comment!)
        }
    }
}
