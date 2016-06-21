//
//  DayDetailModel.swift
//  Traveller
//
//  Created by Teng on 6/20/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

class DayDetailModel: DataModel {
    
    func addNewDayDetail(day: DayDetailBean, userId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/daily/add"
        
        print("day detail start time:\(DataBean.timeFormatter.stringFromDate(day.startTime))")
        
        let parameters = ["token": token,
                          "user_id": userId,
                          "plan_id": day.planID,
                          "post_id": "",
                          "start_time": DataBean.timeFormatter.stringFromDate(day.startTime),
                          "end_time": DataBean.timeFormatter.stringFromDate(day.endTime),
                          "destination": day.place,
                          "latitude": Double(day.coordinate.latitude),
                          "longitude": Double(day.coordinate.longitude),
                          "type": day.type]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters as? [String : AnyObject], encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        try DataModel.filterResponse(response)
                        fulfill(true)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
        
    }

    func getDayDetails(planId: String) -> Promise<[DayDetailBean]> {
        let requestURL = DataModel.baseURL + "/daily/tour"
        
        let parameters = ["token": token, "id": planId]
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        
                        let news = jsonData["details"].array!.map { day -> DayDetailBean in
                            let id = day["id"].string!
                            let start = day["start_time"].string!
                            let end = day["end_time"].string!
                            let place = day["destination"].string!
                            let latitude = day["latitude"].double!
                            let longitude = day["longitude"].double!
                            let type = day["type"].int!
                            
                            return DayDetailBean(id: id, planID: planId, postID: nil, startTime: start, endTime: end, place: place, latitude: latitude, longitude: longitude, type: type)
                        }
                        
                        fulfill(news)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
        
    }

    func deleteDayDetail(detailId: String, userId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/daily/delete/\(token)/\(userId)/\(detailId)"
        
        return Promise { fulfill, reject in
            Alamofire.request(.DELETE, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        try DataModel.filterResponse(response)
                        
                        fulfill(true)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
}