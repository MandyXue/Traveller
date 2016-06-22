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
import Qiniu
import MapKit

class PostModel: DataModel {
    
    static let upManager = QNUploadManager()
    
    // TODO:1-1获取附近post列表
    func getAroundPost(mapSpan: MKCoordinateSpan, center: CLLocationCoordinate2D) -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + "/post/nearby"
        
        let leftLong = center.longitude - mapSpan.longitudeDelta/2
        let rightLong = center.longitude + mapSpan.longitudeDelta/2
        
        let topLat = center.latitude + mapSpan.latitudeDelta/2
        let bottomLat = center.latitude - mapSpan.latitudeDelta/2
        
        
        let parameters = ["token": token, "leftLongitude": leftLong, "rightLongitude": rightLong, "topLatitude": topLat, "bottomLatitude": bottomLat]
        return Promise { fulfill, reject in
            Alamofire.request(.POST, requestURL, parameters: parameters as? [String : AnyObject], encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let posts = jsonData["post"].array!.map { post -> PostBean in
                            let id = post["id"].string!
                            let title = post["title"].string!
                            let address = post["locationDesc"].string!
                            let latitude = post["latitude"].double!
                            let longitude = post["longitude"].double!
                            let summary = post["summary"].string!
                            let creatorId = post["createrId"].string!
                            let createDate = post["createDate"].string!
                            
                            return PostBean(id: id, title: title, address: address, summary: summary, latitude: latitude, longitude: longitude, creatorID: creatorId, createDate: createDate, imagesURL: [])
                        }
                        fulfill(posts)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 2-1获取post的详情
    func getPostDetail(byPostID id:String) -> Promise<PostBean> {
        let requestURL = DataModel.baseURL + "/post/detail"
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
    
        
    // 获取图片上传token
    func getUpToken() ->Promise<String> {
        let requestURL = DataModel.baseURL + "/\(token)/uptoken"
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: nil, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        fulfill(jsonData["uptoken"].string!)
                    } catch {
                        reject(error)
                    }
            }
        }
    }
    
    // 3-1上传图片到云服务器
    func uploadImageToQiniu(images: [UIImage], uptoken: String) -> [Promise<String>] {
        
        let datas = images.map { UIImagePNGRepresentation($0)! }
        let promises = datas.map { data -> Promise<String> in
            return Promise { fulfill, reject in
                PostModel.upManager.putData(data, key: nil, token: uptoken, complete: { info, key, response in
//                        print("key:\(key)")
//                        print("response:\(response)")
                    if info.statusCode == 200 {
                        fulfill("http://7xutg8.com1.z0.glb.clouddn.com/\(response["key"] as! String)")
                    } else {
                        reject(DataError.UploadImageFail)
                    }
                }, option: nil)

            }
        }
        return promises
    }
    
    // 5-1获取一个用户推送的post列表
    func getPosts(byUserID id: String) -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + "/post/posts"
        let parameters = ["token": token, "id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let posts = jsonData["post"].array!.map { post -> PostBean in
                            let id = post["id"].string!
                            let title = post["title"].string!
                            let url = post["imageURL"].string!
                            let location = post["location"].string!
                            
                            return PostBean(id: id, title: title, address: location, summary: "", latitude: 0, longitude: 0, creatorID: "", createDate: "1999-01-01", imagesURL: [url])
                        }
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
//        let post = ["title": newPost.title,
//                    "creatorId": newPost.creatorID,
//                    "locationDesc": newPost.address,
//                    "latitude": newPost.location.latitude,
//                    "longitude": newPost.location.longitude,
//                    "summary": newPost.summary,
//                    "createDate": DataBean.onlyDateFormatter.stringFromDate(newPost.createDate)]
        let urls = newPost.imagesURL
        
        let parameters = ["token": token, "title": newPost.title, "creatorId": newPost.creatorID, "locationDesc": newPost.address, "latitude": newPost.location.latitude, "longitude": newPost.location.longitude, "summary": newPost.summary, "createDate": DataBean().dateFormatter.stringFromDate(newPost.createDate), "imageURL": urls]
        return Promise { fulfill, reject in
//            Alamofire.request(.POST, requestURL, parameters: parameters as! [String : AnyObject])
            
            
            Alamofire.request(.POST, requestURL, parameters: parameters as? [String: AnyObject], encoding: .URL, headers: nil)
                .responseJSON { response in
                    print(response.request!)
                    
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
    
    // 7-1根据用户ID获取用户正在watch的post
    func getWatchingPosts(byUserID id: String) -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + "/post/watching"
        let parameters = ["token": token, "user_id": id]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let posts = jsonData["post"].array!.map { post -> PostBean in
                            let id = (post["id"].string == nil) ? "": post["id"].string!
                            let title = (post["title"].string == nil) ? "": post["title"].string!
                            let url = (post["imageURL"].string == nil) ? "": post["imageURL"].string!
                            let location = (post["location"].string == nil) ? "": post["location"].string!
                            let summary = (post["summary"].string == nil) ? "": post["summary"].string!
                            
                            return PostBean(id: id, title: title, address: location, summary: summary, latitude: 0, longitude: 0, creatorID: "", createDate: "1999-01-01", imagesURL: [url])
                        }
                        fulfill(posts)
                    } catch {
                        print(error)
                        reject(error)
                    }
            }
        }
    }
    
    // 7-2查询所有post中title，location和summary里的相关关键词信息
    func searchPosts(byKeyword key: String) -> Promise<[PostBean]> {
        let requestURL = DataModel.baseURL + "/posts/search"
        let parameters = ["keyword": key]
        
        return Promise { fulfill, reject in
            Alamofire.request(.GET, requestURL, parameters: parameters, encoding: .URL, headers: nil)
                .responseJSON { response in
                    do {
                        let jsonData = try DataModel.filterResponse(response)
                        
                        let posts = jsonData["post"].array!.map { post -> PostBean in
                            let id = post["id"].string!
                            let title = post["title"].string!
                            let url = post["imageURL"].string!
                            let location = post["location"].string!
                            let summary = post["summary"].string!
                            
                            return PostBean(id: id, title: title, address: location, summary: summary, latitude: 0, longitude: 0, creatorID: "", createDate: "1999-01-01", imagesURL: [url])
                        }
                        fulfill(posts)
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