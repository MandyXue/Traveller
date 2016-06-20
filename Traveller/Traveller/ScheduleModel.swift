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
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "userID": userId]
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                            
                        } else {
                            print("save new schedule response:")
                            print(jsonData)
                            
                            let news = [ScheduleBean]()
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