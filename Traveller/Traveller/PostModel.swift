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
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 2-1获取post的详情
    func getPostDetailByID() -> Promise<PostBean> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 2-2获取post的评论
    func getCommentsByPostID() -> Promise<CommentBean> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
    // 2-3获取post的creator的信息
    func getCreatorDetailByPostID() -> Promise<UserBean> {
        let requestURL = baseURL + ""
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: nil, encoding: .URL, headers: nil)
        }
    }
    
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