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
    var startDate: NSDate
    
    // From remote
    init(scheduleID id: String, creatorId: String, destination: String, order: Int, imageURL: String?, startDate: String) {
        self.id = id
        self.creatorId = creatorId
        self.destination = destination
        self.order = order
        self.imageURL = imageURL
        self.startDate = DataBean().onlyDateFormatter.dateFromString(startDate)!
    }
    
    // From local
    init(creatorId: String, destination: String, order: Int, imageURL: String?, startDate: NSDate) {
        self.creatorId = creatorId
        self.destination = destination
        self.order = order
        self.imageURL = imageURL
        self.startDate = startDate
    }
}