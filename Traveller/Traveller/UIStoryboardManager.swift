//
//  UIStoryboardManager.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func traveller_homeStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Home", bundle: nil)
    }
    
    class func traveller_scheduleStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Schedule", bundle: nil)
    }
    
    class func traveller_followingStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Following", bundle: nil)
    }
    
    class func traveller_meStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Me", bundle: nil)
    }
    
    class func traveller_welcomeStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Welcome", bundle: nil)
    }
    
    class func traveller_signupStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Signup", bundle: nil)
    }
    
    class func traveller_loginStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Login", bundle: nil)
    }
    
    class func traveller_rootStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "Root", bundle: nil)
    }
    
    class func traveller_postStoryboard() -> UIStoryboard {
        return UIStoryboard.init(name: "PostDetail", bundle: nil)
    }
}