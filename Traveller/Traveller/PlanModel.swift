//
//  PlanModel.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import Alamofire


class PlanModel: DataModel {
    
    func addNewPlan(plan: PlanBean) -> Promise<String?> {
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "post": plan]
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
                            print("save new plan response:")
                            print(jsonData)
                            fulfill("new plan id")
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }

    }
    
    
    func getPlans(scheduleId: String, userId: String) -> Promise<[PlanBean]> {
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "id": scheduleId]
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
                            
                            let news = [PlanBean]()
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