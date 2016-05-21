//
//  RootTabBarController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        return UIStoryboard.traveller_rootStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configs : [NSDictionary] = [
            ["Title": "Home",
                "ImageName": "home",
                "SelectedImageName": "home-selected",
                "ViewController": HomeMapViewController.loadFromStoryboard()],
            ["Title": "Following",
                "ImageName": "following",
                "SelectedImageName": "following-selected",
                "ViewController": FollowingTableViewController.loadFromStoryboard()],
            ["Title": "Schedule",
                "ImageName": "schedule",
                "SelectedImageName": "schedule-selected",
                "ViewController": TimelineTableViewController.loadFromStoryboard()],
            ["Title": "Me",
                "ImageName": "me",
                "SelectedImageName": "me-selected",
                "ViewController": MeTableViewController.loadFromStoryboard()]
        ]
        
        var controllers = [UIViewController]()
        
        for config in configs {
            let viewController = config["ViewController"] as! UIViewController
            viewController.tabBarItem = UITabBarItem.init(title: config["Title"] as? String, image: UIImage(named: config["ImageName"] as! String)!.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: config["SelectedImageName"] as! String))
            controllers.append(viewController)
        }
        
        self.setViewControllers(controllers, animated: false)
        
        // tabbar style
        self.tabBar.backgroundImage = UIImage.getImageWithColor(UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1), size: CGSize(width: 320, height: 49))
        let selectedColor = UIColor(red: 255/255, green: 211/255, blue: 0/255, alpha: 1)
        UITabBar.appearance().tintColor = selectedColor
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], forState:.Selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImage {
    static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}