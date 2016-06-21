//
//  ErrorCode.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

enum HttpError: ErrorType {
    case ResponseError
    case InternetError
    case StatusNot200
}

enum DataError: ErrorType {
    case ResponseInvalid
    case TokenInvalid
    case UnknowError
}


enum UserError: ErrorType {
    case GetUserInfoFailled
    case InvalidEmail
    case SignupFailed
    case RepeatEmail
    case RepeatName
    case PassEmpty
    case EmailEmpty
    case LoginFailed
    case NotMatch
}

enum CommentError: ErrorType {
    case PostIdEmpty
    case CreatorIdEmpty
    case ContentEmpty
    case CommentFailed
    case UserNotExist
    case PostNotExist
    case IdEmpty
    case GetFailed
    case RequestFailed
}

enum PostError: ErrorType {
    case TokenEmpty
    case IdEmpty
    case IdNotExist
    case CommentIdEmpty
    case GetFailed
    case UserIdEmpty
    case UserNotExist
    case ParameterEmpty
    case CommentIdNotExist
}

enum ScheduleError: ErrorType {
    case DestinationEmpty
    case ScheduleDateEmpty
    case ScheduleNotExist
}

enum DayDetailError: ErrorType {
    case PlanIdEmpty
    case PlanIdNotExist
    case GetFailed
    case PostIdEmpty
    case PostIdNotExist
    case DayDetailIdEmpty
    case DayDetailIdNotExist
    case DeleteFailed
}