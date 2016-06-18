//
//  CommentModel.swift
//  Traveller
//
//  Created by Teng on 6/17/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON


class CommentModel: DataModel {
    // 增加一条评论
    func addComment() {
        
    }

    // 13-2根据用户ID获取用户评论历史列表
    func getComments(byUserID id:String) -> Promise<[CommentBean]> {
        let requestURL = baseURL + "/comment/list"
        let parameters = ["token": token, "id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
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
    
    func addNewComment(comment: CommentBean) -> Promise<Bool> {
        let requestURL = baseURL + "/comment/submit"
        let parameters = ["token": token, "": ""]
        
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
    
    
}