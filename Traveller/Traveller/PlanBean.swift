//
//  PlanBean.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

class PlanBean: DataBean {
    var id: String?
    var scheduleId: String
    var travelDate: String
    var content: String
    
    // From remote
    init (planId id: String, scheduleId: String, date: String, content: String) {
        self.id = id
        self.scheduleId = scheduleId
        self.travelDate = date
        self.content = content
    }
    
    // From local
    init (scheduleId id: String, date: NSDate, content: String) {
        self.scheduleId = id
        self.travelDate = DataBean.dateFormatter.stringFromDate(date)
        self.content = content
    }
}