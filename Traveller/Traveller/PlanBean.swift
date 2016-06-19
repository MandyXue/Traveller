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
    var content: String
    
    // From remote
    init (planId id: String, scheduleId: String, content: String) {
        self.id = id
        self.scheduleId = scheduleId
        self.content = content
    }
    
    // From local
    init (scheduleId id: String, content: String) {
        self.scheduleId = id
        self.content = content
    }
}