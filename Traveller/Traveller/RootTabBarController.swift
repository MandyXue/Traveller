//
//  RootTabBarController.swift
//  Traveller
//
//  Created by MandyXue on 16/5/20.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class RootTabBarController: RAMAnimatedTabBarController {

    // MARK: - BaseViewController
    
    static func loadFromStoryboard() -> UIViewController {
        let vc = UIStoryboard.traveller_rootStoryboard().instantiateViewControllerWithIdentifier(self.traveller_className())
        let nc: UINavigationController = UINavigationController.init(rootViewController: vc)
        return nc
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        let configs : [NSDictionary] = [
            ["Title": "Home",
                "ImageName": "home",
                "ViewController": HomeMapViewController.loadFromStoryboard(),
                "animation": RAMCustomTopTransitionAnimation()],
            ["Title": "Discover",
                "ImageName": "following",
                "ViewController": PostListTableViewController.loadFromStoryboard(),
                "animation": RAMBounceAnimation()],
            ["Title": "Schedule",
                "ImageName": "schedule",
                "ViewController": TimelineTableViewController.loadFromStoryboard(),
                "animation": RAMCustomLeftTransitionAnimation()],
            ["Title": "Me",
                "ImageName": "me",
                "ViewController": MeTableViewController.loadFromStoryboard(),
                "animation": RAMRotationAnimation()]
        ]
        
        var controllers = [UIViewController]()
        
        for config in configs {
            let viewController = config["ViewController"] as! UIViewController
            let tabbarItem = RAMAnimatedTabBarItem.init(title: config["Title"] as? String, image: UIImage(named: config["ImageName"] as! String)!.imageWithRenderingMode(.AlwaysOriginal), tag: 0)
            // set default text&icon color
            tabbarItem.textColor = UIColor.whiteColor()
            tabbarItem.iconColor = UIColor.whiteColor()
            // set tabbaritem animation
            tabbarItem.animation = config["animation"] as! RAMItemAnimation
            viewController.tabBarItem = tabbarItem
            controllers.append(viewController)
        }
        
        self.setViewControllers(controllers, animated: false)
        
        // tabbar style
        let selectedColor = UIColor(red: 255/255, green: 211/255, blue: 0/255, alpha: 1)
        self.changeSelectedColor(selectedColor, iconSelectedColor: selectedColor)
        self.tabBar.backgroundImage = UIImage.getImageWithColor(UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1), size: CGSize(width: 320, height: 49))
        
        // super view did load必须在上面后调用，否则没有tab会崩
        super.viewDidLoad()
        
        
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