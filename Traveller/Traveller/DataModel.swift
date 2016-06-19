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
    let baseURL = "http://localhost:8000"
    var token:String
    var userID:String
    
    init () {
        // 每次init时从NSUserDefault中取token和userid
        // TODO:考虑能不能弄成单例模式
        token = "1ad1658b-1eff-4555-b1fd-f219f8d621da"
        userID = ""
    }
    
    // 处理http response抛出的异常
    func filterResponse(response: Response<AnyObject, NSError>) throws -> JSON {
        print("http response")
        print(response)
        if let serverResp = response.response {
            if serverResp.statusCode < 200 || serverResp.statusCode > 299 {
                throw HttpError.ResponseError
            } else {
                if let result = response.result.value {
                    let jsonData = JSON(result)
                    return jsonData
                } else {
                    throw DataError.ResponseInvalid
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