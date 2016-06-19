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
    
    func login(name:String, password pass:String) -> Promise<Bool> {
        let requestURL = baseURL + "/user/login/\(name)"
        let parameters = ["name": name, "password": pass]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        print(jsonData)
                        
                    } catch {
                        print(error)
                    }
            }
        }
    }
    
    func signup(newUser: UserBean) ->Promise<Bool> {
        let requestURL = baseURL + "/user/register/\(newUser.username)"
        let parameters = ["name": newUser.username, "password": newUser.password!, "email": newUser.email]
        
        return Promise { fulfill, reject in
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
    
    // 5-1获取一个用户推送的post列表
    func getPosts(byUserID id:String) -> Promise<[PostBean]> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON{ response in
                    
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
    
    //10-1根据用户ID获取用户正在following的用户列表
    func getFollowing(byUserID id:String) -> Promise<[UserBean]> {
        let requestURL = baseURL + "/user/\(token)/\(id)/following"
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        print(jsonData)
                        
                        let errCode = jsonData["errCode"].int!
                        if errCode != 0 {
                        } else {
                            let users = [UserBean]()
                            print("jsonData")
                            print(jsonData)
                            
                            fulfill(users)
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }

            }
        }
    }
}