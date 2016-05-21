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
    var image: UIImage
    
    // MARK: - MKAnnotation Property
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
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
        self.subtitle = post.detail
        if post.images.count != 0 {
            self.image = post.images.first!
        } else {
            self.image = UIImage()
            print(self.image)
        }
    }
}
