//
//  ErrorCode.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

// TODO: 如何将错误码和错误信息绑定

enum HttpError: ErrorType {
    case ResponseError
    case InternetError
}

enum DataError: ErrorType {
    case ResponseInvalid
}

enum SignupError: ErrorType {
    case InvalidEmailI(coinNeeded: Int)
    case SignupFailled
    case RepeatEmail
    case RepeatName
}