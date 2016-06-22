//
//  DataModel.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class DataModel {
    static let baseURL = "http://192.168.199.241:8000"
    var token:String
    var userID:String
    var name:String
    
    init () {
        // 每次init时从NSUserDefault中取token和userid
        // TODO:考虑能不能弄成单例模式
        token = NSUserDefaults.standardUserDefaults().valueForKey("token") as! String
        userID = NSUserDefaults.standardUserDefaults().valueForKey("id") as! String
        name = NSUserDefaults.standardUserDefaults().valueForKey("name") as! String
    }
    
    // 处理http response抛出的异常
    class func filterResponse(response: Response<AnyObject, NSError>) throws -> JSON {
//        print("http response")
//        print(response)
        if let serverResp = response.response {
            if serverResp.statusCode < 200 || serverResp.statusCode > 299 {
                throw HttpError.StatusNot200
            } else {
                if let result = response.result.value {
                    let jsonData = JSON(result)
                    
                    let errCode = jsonData["errCode"].int!
                    if 105 == errCode {
                        print("get error 105")
                        print(response)
                        
                        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
                        
                        throw DataError.TokenInvalid
                    } else if 0 == errCode {
                        return jsonData
                    } else {
                        throw DataBean.filterErrorCode(errCode)
                    }
                } else {
                    throw HttpError.ResponseError
                }
            }
        } else {
            // 没有response，可能是网络断了
            throw HttpError.InternetError
            
        }
    }
    
    // 下载数组中所有图片
    func getImages(urls: [String]) -> [Promise<UIImage>] {
        let allRequest = urls.map { url -> Promise<UIImage> in
            return Promise { fulfill, reject in }
        }
        
        return allRequest
    }
}