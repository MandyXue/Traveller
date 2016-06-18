//
//  ErrorCode.swift
//  Traveller
//
//  Created by Teng on 6/18/16.
//  Copyright © 2016 AppleClub. All rights reserved.
//

import Foundation

enum SignupError: ErrorType {
    case InvalidEmailI(coinNeeded: Int)
    case RepeatEmail
    case RepeatName
}