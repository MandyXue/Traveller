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
    
    // 13-1提交评论
    func addNewComment(newComment: CommentBean) -> Promise<Bool> {
        let requestURL = baseURL + "/comment/submit"
        let parameters = ["token": token, "content": newComment.content, "post_id": newComment.postID, "creator_id": userID]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                        } else {
                            print("save new comment response:")
                            print(jsonData)
                            
                            fulfill(true)
                        }
                    } catch {
                        print(error)
                    }
            }
        }
    }

    // TODO:13-2根据用户ID获取用户评论历史列表
    func getComments(byUserID id:String) -> Promise<[CommentBean]> {
        let requestURL = baseURL + "/comment/list"
        let parameters = ["token": token, "creator_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try self.filterResponse(response)
                        let errCode = jsonData["errCode"].int!
                        
                        if errCode != 0 {
                            // 错误处理
                        } else {
                            print("get comments by user id:")
                            print(jsonData)
                            let jsonComment = jsonData["comments"].array!
                            
                            let comments = jsonComment.map { raw -> CommentBean in
                                let id = raw["id"].string!
                                let postId = raw["postId"].string!
                                let creatorAvatar = raw["creatorAvatar"].string
                                let content = raw["content"].string!
                                let createDate = raw["createDate"].string!
                                let creatorId = raw["creatorId"].string!
                                
                                return CommentBean(commentId: id, creatorId: creatorId, avatarURL: creatorAvatar, content: content, postID: postId, createDate: createDate)
                            }
                            
                            fulfill(comments)
                        }
                    } catch {
                        print(error)
                    }
            }
        }
    }
}