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
                        userInfo.setObject(name, forKey: "name")

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
        
        print("request:\(requestURL)")
        print("token:\(token)")
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON{ response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        print(jsonData)
                        let userInfo = jsonData["data"]
                        let user = self.formatUser(fromRemote: userInfo)
                        
                        
                        let follow = jsonData["errMessage"].string
                        if let _ = follow {
                            let followRelation = follow! == "following" ? true : false
                            user.isFollowed = followRelation
                        }
                        
                        user.id = id
                        fulfill(user)
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
                            let users = usersInfo.map { self.formatUser(fromRemote: $0, following: true) }
                            fulfill(users)
                        } else {
                            usersInfo = jsonData["follower_List"].array!
                            let users = usersInfo.map { self.formatUser(fromRemote: $0, following: false) }
                            fulfill(users)
                        }
                        
                    } catch {
                        print(error)
                        reject(error)
                    }

            }
        }
    }
    
    func modifyUserInfo(newUserInfo: UserBean) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/info/update"
        
        let parameters = ["token": token,
                          "userid": newUserInfo.id!,
                          "avatar": newUserInfo.avatarURL == nil ? "" : newUserInfo.avatarURL!,
                          "location": newUserInfo.place == nil ? "" : newUserInfo.place!,
                          "gender": newUserInfo.gender! ? 1 : 2,
                          "summary": newUserInfo.summary == nil ? "" : newUserInfo.summary!,
                          "homepage": newUserInfo.homepage == nil ? "" : newUserInfo.homepage!]
        
        return Promise { fulfill, reject in
            Alamofire.request(.PUT, requestURL, parameters: parameters as? [String : AnyObject], encoding: .URL, headers: nil)
                .responseJSON{ response in
                    do {
                        try DataModel.filterResponse(response)
                        
                        fulfill(true)
                    } catch let err {
                        reject(err)
                    }
            }
        }
    }
    
    func followUser(followingId id:String, followeeId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/\(token)/\(id)/follow/\(followeeId)"
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        try DataModel.filterResponse(response)
                        fulfill(true)
                    } catch {
                        print(error)
                    }
            }
        }
    }
    
    func cancelFollow(followingId id:String, followeeId: String) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/user/\(token)/\(id)/follow/\(followeeId)"
        
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
    
    func formatUser(fromRemote userInfo: JSON, following: Bool) -> UserBean {

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
        let followee_id = userInfo["followee_id"].string
        let follower_id = userInfo["follower_id"].string
        
        var user = UserBean(name: name, place: place, gender: gender, summary: summary, email: email, homepage: homepage, registerDate: registerDate, followerNum: followerNum, followingNum: followeingNum, avatarURL: avatarURL)
        if following {
            user.id = followee_id
        } else {
            user.id = follower_id
        }
        
        
        
        return user
    }
}