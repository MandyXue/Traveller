//
//  MapDataPointAnnotation.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import MapKit

class MapDataPointAnnotation: NSObject, MKAnnotation {
    
    var pointId: Int = 0
    var image: UIImage   // 缩略图
    
    // MARK: - MKAnnotation Property
    
    var coordinate: CLLocationCoordinate2D  // GPS
    var title: String?                      // annotation的标题
    var subtitle: String?                   // annotation的副标题
    
    // MARK: - Init
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
    }
    
    init(post: PostModel) {
        self.coordinate = post.location
        self.title = post.place
        self.subtitle = post.address
        if post.images.count != 0 {
            self.image = post.images.first!
        } else {
            self.image = UIImage()
            print(self.image)
        }
    }
}
