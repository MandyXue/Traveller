//
//  PostModel.swift
//  Traveller
//
//  Created by MandyXue on 16/5/21.
//  Copyright © 2016年 AppleClub. All rights reserved.
//

import Foundation
import MapKit

class PostModel: NSObject {
    
    var pointId: Int = 0
    
    // MARK: - MKAnnotation Property
    
    var place: String?
    var comment: String?
    var location: CLLocationCoordinate2D
    var images: [UIImage] = []
    
    // MARK: - Init
    
    init(place: String, comment: String, location: CLLocationCoordinate2D) {
        self.place = place
        self.comment = comment
        self.location = location
        print("init finished")
    }
    
    // MARK: - Methods
    
    func addImage(image: UIImage) {
        self.images.append(image)
    }
}
