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
        let parameters = ["name": newUser.username, "password": newUser.password!, "email": newUser.email]
        
        return Promise{ fulfill, reject in
            Alamofire.request(.POST, "http://localhost:8000/user/register/\(newUser.username)", parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    if let serverResp = response.response {
                        if serverResp.statusCode < 200 || serverResp.statusCode > 299 {
                            let error = NSError(domain: "http", code: 100, userInfo: ["errDesc": "Server answers with a wrong status:\(serverResp.statusCode)"])
                            reject(error)
                        } else {
                            if let result = response.result.value {
                                let jsonData = JSON(result)
                                let errCode = jsonData["errCode"].int!
                                if errCode != 0 {
                                    let error = NSError(domain: "signup", code: errCode, userInfo: ["errDesc": "Signup fialed with error:\(jsonData["errMessage"].string!)"])
                                    reject(error)
                                } else {
                                    fulfill(true)
                                }
                            }
                        }
                    } else {
                        // 没有response，可能是网络断了
                        fulfill(false)
                    }
                    
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(JSON(response.result.value!))
            }
        }
    }
}