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
    
    class func login(name:String, password pass:String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/login/\(name)"
        let parameters = ["name": name, "password": pass]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)

                        // 将token和userId存NSUserDefault
                        let token = jsonData["token"].string!
                        let currentId = jsonData["userId"].string!
                        
                        let userInfo = NSUserDefaults.standardUserDefaults()
                        userInfo.setObject(token, forKey: "token")
                        userInfo.setObject(currentId, forKey: "id")
                        fulfill(true)
                    } catch {
                        reject(error)
                    }
            }
        }
    }
    
    class func signup(newUser: UserBean) ->Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/register/\(newUser.username)"
        let parameters = ["name": newUser.username, "password": newUser.password!, "email": newUser.email]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
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
    
    
    // 2-3获取post的creator的信息
    func getCreatorDetail(byPostID id:String) -> Promise<UserBean> {
        let requestURL = DataModel.baseURL + "/post/creator"
        let parameters = ["token": token, "id": id]
        
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let creator = jsonData["creator"]
                        fulfill(self.formatUser(fromRemote: creator))
                    } catch DataError.TokenInvalid {
                        print("token invalid")
                        reject(DataError.TokenInvalid)
                    } catch {
                        reject(error)
                    }
            }
        }
    }
    
    // 8-1根据用户id获取用户个人基本信息
    func getUserDetail(byUserID id: String) -> Promise<UserBean> {
        let requestURL = DataModel.baseURL + "/user/\(id)/info"
        let parameters = ["token": token]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON{ response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let userInfo = jsonData["data"]
                        
                        fulfill(self.formatUser(fromRemote: userInfo))
                    } catch DataError.TokenInvalid {
                        print("token invalid")
                        reject(DataError.TokenInvalid)
                    } catch {
                        reject(error)
                    }
            }
        }
    }

    
    //10-1根据用户ID获取用户正在following的用户列表
    func getFollowList(byUserID id:String, isFollowing: Bool) -> Promise<[UserBean]> {
        var requestURL:String
        if isFollowing {
            requestURL = DataModel.baseURL + "/user/\(token)/\(id)/following"
        } else {
            requestURL = DataModel.baseURL + "/user/\(token)/\(id)/follower"
        }
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)

                        print("jsonData")
                        print(jsonData)
                        
                        var usersInfo:[JSON]
                        if isFollowing {
                            usersInfo = jsonData["following_List"].array!
                        } else {
                            usersInfo = jsonData["follower_List"].array!
                        }
                        let users = usersInfo.map { self.formatUser(fromRemote: $0) }
                        
                        fulfill(users)
                    } catch {
                        print(error)
                        reject(error)
                    }

            }
        }
    }
    
    func formatUser(fromRemote userInfo: JSON) -> UserBean {
        let name = userInfo["name"].string!
        let place = userInfo["location"].string
        let gender = userInfo["gender"].int
        let summary = userInfo["summary"].string
        let email = userInfo["email"].string!
        let homepage = userInfo["homepage"].string
        let registerDate = userInfo["register_date"].string!
        let followerNum = userInfo["follower_num"].int!
        let followeingNum = userInfo["following_num"].int!
        let avatarURL = userInfo["avatar"].string
        
        let user = UserBean(name: name, place: place, gender: gender, summary: summary, email: email, homepage: homepage, registerDate: registerDate, followerNum: followerNum, followingNum: followeingNum, avatarURL: avatarURL)
        
        return user
    }
}