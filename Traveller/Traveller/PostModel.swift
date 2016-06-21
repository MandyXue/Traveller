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
import SwiftyJSON

class PostModel: DataModel {
    
    // TODO:1-1获取附近post列表
    func getAroundPost() -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 2-1获取post的详情
    func getPostDetail(byPostID id:String) -> Promise<PostBean> {
        let requestURL = DataModel.baseURL + "post/detail"
        let parameters = ["token": token, "id": id]
        
        print("request:\(requestURL)")
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URLEncodedInURL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
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
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // TODO:2-2获取post的评论
    func getComments(byPostID id:String) -> Promise<[CommentBean]> {
        let requestURL = DataModel.baseURL + "/comment/plist"
        let parameters = ["token": token, "post_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                        } else {
                            let comments = [CommentBean]()
                            print("comments:")
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
    
    // TODO:获取图片上传token
    func getUpToken() ->Promise<String> {
        let requestURL = DataModel.baseURL + ""
        let parameters = ["token": token]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)

                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // TODO:3-1上传图片到云服务器
    func uploadImageToQiniu(images: [UIImage]) -> Promise<[String]> {
        let requestURL = DataModel.baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
            }
        }
    }
    
    // TODO:5-1获取一个用户推送的post列表
    func getPosts(byUserID id: String) -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + "/post/posts"
        let parameters = ["token": token, "id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        print("get user posts:")
                        print(jsonData)
                        let posts = [PostBean]()
                        fulfill(posts)

                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // TODO:6-1推送一条新的post
    func addNewPost(newPost: PostBean) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/post/new"
        let post = []
        let urls = newPost.imagesURL
        
        let parameters = ["token": token, "post": post, "imageURLs": urls]
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
    
    // TODO:13-3根据评论ID获取post
    func getPost(byCommentID id: String) -> Promise<PostBean> {
        let requestURL = DataModel.baseURL + "/post/comment/\(id)"
        let parameters = ["token": token]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let post = self.formatPost(jsonData)
                        fulfill(post)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    func formatPost(jsonData: JSON) -> PostBean {
        let id = jsonData["post"]["id"].string!
        let title = jsonData["post"]["title"].string!
        let address = jsonData["post"]["locationDesc"].string!
        let summary = jsonData["post"]["summary"].string!
        let lat = jsonData["post"]["latitude"].double!
        let lon = jsonData["post"]["longitude"].double!
        let creatorId = jsonData["post"]["creatorId"].string!
        let createDate = jsonData["post"]["createDate"].string!
        let imagesURL = jsonData["post"]["imageURLs"].array!.map { $0["imageUrl"].string! }
        
        return PostBean(id: id, title: title, address: address, summary: summary, latitude: lat, longitude: lon, creatorID: creatorId, createDate: createDate, imagesURL: imagesURL)
    }
}