//
//  DataBean.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

class DataBean {
    let dateFormatStr = "yyyy-MM-dd HH:ss:mm"
    let timeFormatStr = "HH:ss:mm"
    static let dateFormatter = NSDateFormatter()
    static let timeFormatter = NSDateFormatter()
    
    init () {
        DataBean.dateFormatter.dateFormat = dateFormatStr
        DataBean.timeFormatter.dateFormat = timeFormatStr
    }
}