//
//  PostModel.swift
//  Traveller
//
//  Created by Teng on 6/17/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class PostModel: DataModel {
    
    // 1-1获取附近post列表
    func getAroundPost() -> Promise<[PostBean]> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 2-1获取post的详情
    func getPostDetail(byPostID id:String) -> Promise<PostBean> {
        let requestURL = baseURL + "post/detail"
        let parameters = ["token": token, "id": id]
        
        print("request:\(requestURL)")
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URLEncodedInURL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                            print("resposne error code is:\(errCode)")
                        } else {
                            print("post detail:")
                            print(jsonData)
                            
                            let id = jsonData["post"]["id"].string!
                            let title = jsonData["post"]["title"].string!
                            let address = jsonData["post"]["locationDesc"].string!
                            let summary = jsonData["post"]["summary"].string!
                            let lat = jsonData["post"]["latitude"].double!
                            let lon = jsonData["post"]["longitude"].double!
                            let creatorId = jsonData["post"]["creatorId"].string!
                            let createDate = jsonData["post"]["createDate"].string!
                            let imagesURL = jsonData["post"]["imageURLs"].array!.map { $0["imageUrl"].string! }
                            
                            let post = PostBean(id: id, title: title, address: address, summary: summary, latitude: lat, longitude: lon, creatorID: creatorId, createDate: createDate, imagesURL: imagesURL)
                            
                            fulfill(post)
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 2-2获取post的评论
    func getComments(byPostID id:String) -> Promise<[CommentBean]> {
        let requestURL = baseURL + "/comment/plist"
        let parameters = ["token": token, "post_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                        } else {
                            let comments = [CommentBean]()
                            print("commentkjadsfkljadkslfjaskldfj:")
                            print(jsonData)
                            fulfill(comments)
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 2-3获取post的creator的信息
    func getCreatorDetail(byPostID id:String) -> Promise<UserBean> {
        let requestURL = baseURL + "/post/creator"
        let parameters = ["token": token, "id": id]
        
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                        } else {
//                            print("userksdjfklasjdkfl;ajkdsjf;a")
//                            print(jsonData)
                            
                            let creator = jsonData["creator"]
                            
                            let name = creator["name"].string!
                            let place = creator["location"].string
                            let gender = creator["gender"].int
                            let summary = creator["summary"].string
                            let email = creator["email"].string!
                            let homepage = creator["homepage"].string
                            let registerDate = creator["register_date"].string!
                            
                            let user = UserBean(name: name, place: place, gender: gender, summary: summary, email: email, homepage: homepage, registerDate: registerDate)
                            fulfill(user)
                        }
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 获取图片上传token
    func getUpToken() ->Promise<String> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 3-1上传图片到云服务器
    func loadImageToQiniu() -> Promise<Bool> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 5-1获取一个用户推送的post列表
    func getPostsByUserID() -> Promise<[PostBean]> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 增加一个新的post
    func addNewPost() -> Promise<Bool> {
        let requestURL = baseURL + ""
        let parameters = ["token": "token"]
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
        }
    }
    
    
}