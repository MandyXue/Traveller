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
        let requestURL = DataModel.baseURL + "/user/plan/\(token)/\(userId)/\(scheduleId)"
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                            
                        } else {
                            print("save new schedule response:")
                            print(jsonData)
                            
                            let news = jsonData["planList"].array!.map { plan -> PlanBean in
                                let id = plan["plan_id"].string!
                                let plan = plan["plan"].string!
                                
                                return PlanBean(planId: id, scheduleId: scheduleId, content: plan)
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