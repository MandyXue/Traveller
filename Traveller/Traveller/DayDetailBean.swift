//
//  DayDetailBean.swift
//  Traveller
//
//  Created by Teng on 6/19/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import CoreLocation

class DayDetailBean: DataBean {
    
    var id: String?
    var planID: String
    var postID: String?
    var startTime: NSDate
    var endTime: NSDate
    var place: String
    var coordinate: CLLocationCoordinate2D
    var type: Int  // 0: eating; 1: living; 2: spot
    
    // From remote
    init (id: String, planID: String, postID:String?, startTime: String, endTime: String, place: String, latitude: Double, longitude: Double, type: Int) {
        self.id = id
        self.planID = planID
        self.postID = postID
        self.startTime = DataBean.timeFormatter.dateFromString(startTime)!
        self.endTime = DataBean.timeFormatter.dateFromString(endTime)!
        self.place = place
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.type = type
    }
    
    // From local
    init (planID: String, postID: String?, startTime: NSDate, endTime: NSDate, place: String, latitude: Double, longitude: Double, type: Int) {
        self.planID = planID
        self.postID = postID
        self.startTime = startTime
        self.endTime = endTime
        self.place = place
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.type = type
    }
}