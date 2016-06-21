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
    
    func addNewPlan(plan: PlanBean, userId: String) -> Promise<String> {
        let requestURL = DataModel.baseURL + "/user/plan/\(token)/\(userId)"
        
        let parameters = ["token": token, "id": userId, "scheduleId": plan.scheduleId, "plan": plan.content, "travelDate": "1999-01-01"]
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
    
    
    func getPlans(scheduleId: String, userId: String) -> Promise<[PlanBean]> {
        let requestURL = DataModel.baseURL + "/user/plan/\(token)/\(userId)/\(scheduleId)"
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let news = jsonData["planList"].array!.map { plan -> PlanBean in
                            let id = plan["plan_id"].string!
                            let plan = plan["plan"].string!
                            
                            return PlanBean(planId: id, scheduleId: scheduleId, content: plan)
                        }
                        
                        fulfill(news)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
        
    }
    
    func deletePlan(planId: String, userId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/plan/\(token)/\(userId)/\(planId)"
        
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