//
//  DataBean.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

class DataBean {
    let dateFormatStr = "yyyy-MM-dd HH:mm:ss"
    let timeFormatStr = "HH:mm:ss"
    let onlyDateFormatStr = "yyyy-MM-dd"
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    let onlyDateFormatter = NSDateFormatter()
    
    init () {
        dateFormatter.dateFormat = dateFormatStr
        timeFormatter.dateFormat = timeFormatStr
        onlyDateFormatter.dateFormat = onlyDateFormatStr
    }
    
    class func getErrorMessage(error: ErrorType) -> String {
        var message:String
        switch error {
        case DataError.ResponseInvalid:
            message = "Response格式错误"
        case DataError.TokenInvalid:
            message = "Token失效，需要重新登录"
        
        case HttpError.InternetError:
            message = "网络错误，无法发送请求"
        case HttpError.ResponseError:
            message = "没有获取到Response"
        case HttpError.StatusNot200:
            message = "网络请求错误"
            
        case UserError.GetUserInfoFailled:
            message = "该邮箱已被注册"
        case UserError.InvalidEmail:
            message = "邮箱名不合法"
        case UserError.SignupFailed:
            message = "注册失败"
        case UserError.RepeatEmail:
            message = "邮箱重复"
        case UserError.RepeatName:
            message = "该用户名已被注册"
        case UserError.PassEmpty:
            message = "密码不能为空"
        case UserError.EmailEmpty:
            message = "email不能为空"
        case UserError.LoginFailed:
            message = "登录失败"
        case UserError.NotMatch:
            message = "用户名密码不匹配"
        case UserError.ModifyFailed:
            message = "修改用户信息失败"
        case UserError.CancelFollowFailed:
            message = "取消Follow失败"
        case UserError.FollowExist:
            message = "Follow关系已存在"
        
        case CommentError.PostIdEmpty:
            message = "post id不能为空"
        case CommentError.CreatorIdEmpty:
            message = "creater id不能为空"
        case CommentError.ContentEmpty:
            message = "评论内容不能为空"
        case CommentError.CommentFailed:
            message = "发表评论失败"
        case CommentError.UserNotExist:
            message = "评论者不存在"
        case CommentError.PostNotExist:
            message = "post不存在"
        case CommentError.IdEmpty:
            message = "id不能为空"
        case CommentError.GetFailed:
            message = "获取失败"
        case CommentError.RequestFailed:
            message = "请求失败"
            
        case PostError.TokenEmpty:
            message = "token不能为空"
        case PostError.IdEmpty:
            message = "post id不能为空"
        case PostError.IdNotExist:
            message = "post id不存在"
        case PostError.CommentIdEmpty:
            message = "comment id不能为空"
        case PostError.GetFailed:
            message = "获取失败"
        case PostError.UserIdEmpty:
            message = "用户id不能为空"
        case PostError.UserNotExist:
            message = "用户id不存在"
        case PostError.ParameterEmpty:
            message = "参数不能有空值"
        case PostError.CommentIdNotExist:
            message = "comment id不存在"
            
        case ScheduleError.DestinationEmpty:
            message = "destination不能为空"
        case ScheduleError.ScheduleDateEmpty:
            message = "scheduleDate不能为空"
        case ScheduleError.ScheduleNotExist:
            message = "schedule不存在"
            
        case DayDetailError.PlanIdEmpty:
            message = "plan id不能为空"
        case DayDetailError.PlanIdNotExist:
            message = "plan id不存在"
        case DayDetailError.GetFailed:
            message = "获取失败"
        case DayDetailError.PostIdEmpty:
            message = "post id不能为空"
        case DayDetailError.PostIdNotExist:
            message = "post id不存在"
        case DayDetailError.DayDetailIdEmpty:
            message = "dayDetail id不能为空"
        case DayDetailError.DayDetailIdNotExist:
            message = "dayDetail id不存在"
        case DayDetailError.DeleteFailed:
            message = "删除失败"
            
        default:
            message = "未知错误"
        }
        
        return message
    }
    
    class func filterErrorCode(errCode: Int) -> ErrorType {
        var error:ErrorType
        switch errCode {
        case 101:
            error = UserError.RepeatEmail
        case 102:
            error = UserError.RepeatName
        case 103:
            error = UserError.PassEmpty
        case 104:
            error = UserError.EmailEmpty
        case 105:
            error = DataError.TokenInvalid
        case 106:
            error = UserError.GetUserInfoFailled
        case 107:
            error = UserError.ModifyFailed
        case 108:
            error = UserError.CancelFollowFailed
        case 109:
            error = UserError.FollowExist
        case 201:
            error = UserError.LoginFailed
        case 202:
            error = UserError.PassEmpty
        case 301:
            error = CommentError.PostIdEmpty
        case 302:
            error = CommentError.CreatorIdEmpty
        case 303:
            error = CommentError.ContentEmpty
        case 304:
            error = CommentError.CommentFailed
        case 305:
            error = CommentError.UserNotExist
        case 306:
            error = CommentError.PostNotExist
        case 309:
            error = CommentError.GetFailed
        case 310:
            error = CommentError.RequestFailed
        case 401:
            error = PostError.TokenEmpty
        case 402:
            error = PostError.IdEmpty
        case 403:
            error = PostError.IdNotExist
        case 404:
            error = PostError.CommentIdEmpty
        case 405:
            error = PostError.GetFailed
        case 406:
            error = PostError.UserIdEmpty
        case 407:
            error = PostError.UserNotExist
        case 408:
            error = PostError.ParameterEmpty
        case 409:
            error = PostError.CommentIdNotExist
        case 501:
            error = ScheduleError.DestinationEmpty
        case 502:
            error = ScheduleError.ScheduleDateEmpty
        case 503:
            error = ScheduleError.ScheduleNotExist
        case 701:
            error = DayDetailError.PlanIdEmpty
        case 702:
            error = DayDetailError.PlanIdNotExist
        case 703:
            error = DayDetailError.GetFailed
        case 704:
            error = DayDetailError.PostIdEmpty
        case 705:
            error = DayDetailError.PostIdNotExist
        case 706:
            error = DayDetailError.DayDetailIdEmpty
        case 707:
            error = DayDetailError.DayDetailIdNotExist
        case 708:
            error = DayDetailError.DeleteFailed
        default:
            error = DataError.UnknowError
        }
        
        return error
    }
}