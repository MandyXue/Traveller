//
//  RAMCustomTransitionAnimation.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import UIKit
import RAMAnimatedTabBarController

public class RAMCustomLeftTransitionAnimation : RAMItemAnimation {
    
    public var transitionOptions : UIViewAnimationOptions! = UIViewAnimationOptions.TransitionFlipFromLeft
    
    override init() {
        super.init()
        
        transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
    }
    
    override public func playAnimation(icon : UIImageView, textLabel : UILabel) {
        
        selectedColor(icon, textLabel: textLabel)
        
        UIView.transitionWithView(icon, duration: NSTimeInterval(duration), options: transitionOptions, animations: {
            }, completion: { _ in
        })
    }
    
    override public func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor, defaultIconColor : UIColor) {
        
        if let iconImage = icon.image {
            let renderMode = CGColorGetAlpha(defaultIconColor.CGColor) == 0 ? UIImageRenderingMode.AlwaysOriginal :
                UIImageRenderingMode.AlwaysTemplate
            let renderImage = iconImage.imageWithRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
        textLabel.textColor = defaultTextColor
    }
    
    override public func selectedState(icon : UIImageView, textLabel : UILabel) {
        
        selectedColor(icon, textLabel: textLabel)
    }
    
    
    func selectedColor(icon : UIImageView, textLabel : UILabel) {
        
        if let iconImage = icon.image where iconSelectedColor != nil {
            let renderImage = iconImage.imageWithRenderingMode(.AlwaysTemplate)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
        
        textLabel.textColor = textSelectedColor
    }
}

public class RAMCustomTopTransitionAnimation : RAMCustomLeftTransitionAnimation {
    
    override init() {
        super.init()
        
        transitionOptions = UIViewAnimationOptions.TransitionFlipFromTop
    }
}