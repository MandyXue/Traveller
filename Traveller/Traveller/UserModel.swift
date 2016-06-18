//
//  UserModel.swift
//  Traveller
//
//  Created by Teng on 6/17/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class UserModel: DataModel {
    func login() {
        
    }
    
    func signup(newUser: UserBean) ->Promise<Bool> {
        let requestURL = baseURL + "user/register/\(newUser.username)"
        let parameters = ["name": newUser.username, "password": newUser.password!, "email": newUser.email]
        
        return Promise{ fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        print(jsonData)
                        
                        let errCode = jsonData["errCode"].int!
                        if errCode != 0 {
                            let error = NSError(domain: "signup", code: errCode, userInfo: ["errDesc": "Signup fialed with error:\(jsonData["errMessage"].string!)"])
                            reject(error)
                        } else {
                            fulfill(true)
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 8-1根据用户id获取用户个人基本信息
    func getUserDetail(byUserID id: String) -> Promise<UserBean> {
        
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON{ response in
                    
            }
        }
    }
    
    func signout(userID: String) -> Promise<Bool> {
        let requestURL = baseURL + ""
        let parameters = ["token": "", "id": "id"]
        
        return Promise {fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    print(response)
            }
        }
    }
}