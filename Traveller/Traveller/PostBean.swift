//
//  PostModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import MapKit

class PostBean: DataBean {
    
    var pointId: Int = 0
    
    // MARK: - MKAnnotation Property
    var id: String?
    var title: String                    // 景点名称
    var address: String                  // 景点地址
    var summary: String                   // 景点详细介绍
    var comments = [CommentBean]()     // 景点的相关评论
    var location: CLLocationCoordinate2D  // 景点的GPS信息
    var images = [UIImage]()            // 景点的图片
    var imagesURL = [String]()
    var creator: UserBean?                // 创建者
    var creatorID: String
    var createDate: NSDate
    // MARK: - Init
    
//    override init() {
//        title = ""
//        summary = ""
//        address = ""
//        summary = ""
//        location = CLLocationCoordinate2D()
//        creatorID = ""
//        createDate = NSDate()
//    }
    
    // For remote
    init(id: String, title: String, address: String, summary:String, latitude: Double, longitude: Double, creatorID:String, createDate: String, imagesURL: [String]) {
        self.id = id
        self.title = title
        self.address = address
        self.summary = summary
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.creatorID = creatorID
        self.createDate = NSDate()
        self.imagesURL = imagesURL
    }
    
    // From local
    init(place: String, detail: String, location: CLLocationCoordinate2D, address: String, creatorId: String) {
        self.title = place
        self.summary = detail
        self.location = location
        self.address = address
        
        self.creatorID = creatorId
        self.createDate = NSDate()
        
    }
    
    // From remote2
    init(place: String, detail: String, location: CLLocationCoordinate2D, address: String, creator: UserBean) {
        self.title = place
        self.summary = detail
        self.location = location
        self.address = address
        
        self.creatorID = creator.id!
        self.creator = creator
        self.createDate = NSDate()
        
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
