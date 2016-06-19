//
//  DispatchController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class DispatchController: NSObject {
    class func dispatchToMain()-> UIViewController {
        
//        let token = NSUserDefaults.standardUserDefaults().valueForKey("token") as? String
//        
//        if let _ = token {
            return RootTabBarController.loadFromStoryboard()
//        } else {
//            return WelcomeViewController.loadFromStoryboard()
//        }
    }
}
