//
//  ScheduleBean.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

class ScheduleBean: DataBean {
    var id: String?
    var creatorId: String
    var destination: String
    var order: Int
    var imageURL: String?
    
    // From remote
    init(scheduleID id: String, creatorId: String, destination: String, order: Int, imageURL: String?) {
        self.id = id
        self.creatorId = creatorId
        self.destination = destination
        self.order = order
        self.imageURL = imageURL
    }
    
    // From local
    init(creatorId: String, destination: String, order: Int, imageURL: String?) {
        self.creatorId = creatorId
        self.destination = destination
        self.order = order
        self.imageURL = imageURL
    }
}