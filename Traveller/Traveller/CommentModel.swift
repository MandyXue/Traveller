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
    
    // 2-2获取post的评论
    func getComments(byPostID id:String) -> Promise<[CommentBean]> {
        let requestURL = DataModel.baseURL + "/comment/plist"
        let parameters = ["token": token, "post_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)

                        let comments = jsonData["comments"].array!.map { comment -> CommentBean in
                            let postId = comment["postId"].string!
                            let content = comment["content"].string!
                            let id = comment["id"].string!
                            let creatorAvatarURL = comment["creatorAvatar"].string
                            let time = comment["createDate"].string!
                            let creatorId = comment["creatorId"].string!
                            
                            let name = comment["creator_name"].string!
                            
                            let comment = CommentBean(commentId: id, creatorId: creatorId, avatarURL: creatorAvatarURL, content: content, postID: postId, createDate: time)
                            comment.user = UserBean(id: creatorId, username: name, avatar: nil)
                            
                            return comment
                        }
                        print("comments:")
                        print(jsonData)
                        fulfill(comments)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }

    
    // 13-1提交评论
    func addNewComment(newComment: CommentBean) -> Promise<Bool> {
        let requestURL = DataModel.baseURL + "/comment/submit"
        let parameters = ["token": token, "content": newComment.content, "post_id": newComment.postID, "creator_id": userID]
        
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .URL, headers: nil)
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

    // TODO:13-2根据用户ID获取用户评论历史列表
    func getComments(byUserID id:String) -> Promise<[CommentBean]> {
        let requestURL = DataModel.baseURL + "/comment/list"
        let parameters = ["token": token, "creator_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let jsonComment = jsonData["comments"].array!
                        
                        let comments = jsonComment.map { raw -> CommentBean in
                            let id = raw["id"].string!
                            let postId = raw["postId"].string!
                            let creatorAvatar = raw["creatorAvatar"].string
                            let content = raw["content"].string!
                            let createDate = raw["createDate"].string!
                            let creatorId = raw["creatorId"].string!
                            let postTitle = raw["post_title"].string!
                            let postLocation = raw["post_location"].string!
                            
                            let new = CommentBean(commentId: id, creatorId: creatorId, avatarURL: creatorAvatar, content: content, postID: postId, createDate: createDate)
                            new.postTitle = postTitle
                            new.postLocation = postLocation
                            
                            return new
                        }
                        
                        fulfill(comments)
                    } catch {
                        print(error)
                    }
            }
        }
    }
}