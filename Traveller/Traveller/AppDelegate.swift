//
//  AppDelegate.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import MapKit
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().windows[0].rootViewController = DispatchController.dispatchToMain()
        // set navigation bar style
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.barTintColor = UIColor.customGreenColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

let timeIntervalForOneDay: Double = 24*60*60

extension NSDate {
    static func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        let string = formatter.stringFromDate(date)
        return string
    }
}

extension UIColor {
    public class func customGreenColor() -> UIColor {
        return UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
    }
    
    public class func customGreenColor(alpha: CGFloat) -> UIColor {
        return UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: alpha)
    }
}

extension NSDateFormatter {
    public class func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.timeStyle = .NoStyle
        return formatter.stringFromDate(date)
    }
}

extension UIButton {
    public class func defaultStyle(button:UIButton) {
        button.layer.cornerRadius = button.bounds.height/2
        button.clipsToBounds = true
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
}

extension UIView {
    public class func customSnapshotFromView(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // create an image view
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
}

extension UIViewController {
    func handleErrorMsg(err: ErrorType) {
        switch err {
        case DataError.TokenInvalid:
            
            let vc = WelcomeViewController.loadFromStoryboard()
            HUD.flash(.LabeledError(title: "Error", subtitle: "Your session has expired, please login again"), delay: 1.5)
            self.presentViewController(vc, animated: true, completion: nil)
        default:
            HUD.flash(.LabeledError(title: "Error", subtitle: DataBean.getErrorMessage(err)), delay: 1.5)
        }
    }
}
