//
//  UIViewControllerManager.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol TravellerBaseViewController {
    /**
     return the viewController instance loaded from required storyboard.
     - returns:
     */
    optional static func loadFromStoryboard()-> UIViewController
}

extension UIViewController: TravellerBaseViewController {
    
    class func traveller_className()-> String {
        return String(Mirror(reflecting: self).subjectType).componentsSeparatedByString(".").first!
    }
    
    func traveller_className() -> String {
        return String(Mirror(reflecting: self).subjectType)
    }
    
}