//
//  ScheduleModel.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire

class ScheduleModel: DataModel {
    
    
    func addNewSchedule(schedule: ScheduleBean, userId: String) -> Promise<String> {
        let requestURL = DataModel.baseURL + "/schedule/\(token)/\(userId)/newschedule"
        
        let parameters = ["destination": schedule.destination, "scheduleDate": DataBean.onlyDateFormatter.stringFromDate(schedule.startDate)]
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        let id = jsonData["errMessage"].string!
                        
                        fulfill(id)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }

    }
    
    func getSchedule(userId: String) -> Promise<[ScheduleBean]> {
        let requestURL = DataModel.baseURL + "/schedule/\(token)/\(userId)/list"
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        var i = 0
                        let raws = jsonData["scheduleList"].array!
                        let news = raws.map { schedule -> ScheduleBean in
                            i += 1
                            let id = schedule["id"].string!
                            let destination = schedule["destination"].string!
                            let url = schedule["imageURL"].string
                            let date = schedule["scheduleDate"].string!
                            let creatorId = schedule["creatorId"].string!
                            
                            return ScheduleBean(scheduleID: id, creatorId: creatorId, destination: destination, order: i, imageURL: url, startDate: date)
                        }
                        
                        fulfill(news)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    func deleteSchedule(scheduleId: String, userId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/schedule/\(token)/\(userId)/\(scheduleId)"
        
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