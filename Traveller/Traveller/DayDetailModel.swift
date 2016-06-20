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
    
    func addNewDayDetail(day: DayDetailBean) -> Promise<String?> {
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "post": day]
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
                            fulfill("new day detail id")
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
        
    }

    func getDayDetails(planId: String) -> Promise<[DayDetailBean]> {
        let requestURL = DataModel.baseURL + ""
        
        let parameters = ["token": token, "id": planId]
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
                            
                            let news = [DayDetailBean]()
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