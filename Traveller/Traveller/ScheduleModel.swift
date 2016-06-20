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
    
    
    func addNewSchedule(schedule: ScheduleBean) -> Promise<String?> {
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "post": schedule]
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters as? [String : AnyObject], encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                            fulfill(nil)
                        } else {
                            print("save new schedule response:")
                            print(jsonData)
                            fulfill("new schedule id")
                        }
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
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                            
                        } else {
                            print("get schedles response:")
                            print(jsonData)
                            
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
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }

    }
}