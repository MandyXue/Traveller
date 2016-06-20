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
    static let baseURL = "http://localhost:8000"
    var token:String
    var userID:String
    
    init () {
        // 每次init时从NSUserDefault中取token和userid
        // TODO:考虑能不能弄成单例模式
        token = NSUserDefaults.standardUserDefaults().valueForKey("token") as! String
        userID = NSUserDefaults.standardUserDefaults().valueForKey("id") as! String
        
        //For test
//        token = ""
//        userID = ""
    }
    
    // 处理http response抛出的异常
    class func filterResponse(response: Response<AnyObject, NSError>) throws -> JSON {
        if let serverResp = response.response {
            if serverResp.statusCode < 200 || serverResp.statusCode > 299 {
                throw HttpError.ResponseError
            } else {
                if let result = response.result.value {
                    let jsonData = JSON(result)
                    
                    let errCode = jsonData["errCode"].int!
                    if 105 == errCode {
                        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
                        
                        throw DataError.TokenInvalid
                    } else {
                        return jsonData
                    }
                } else {
                    print("http response")
                    print(response)
                    throw DataError.ResponseInvalid
                }
            }
        } else {
            // 没有response，可能是网络断了
            print("http response")
            print(response)
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