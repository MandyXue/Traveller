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
    var detail: String?
    var comments: [String] = []
    var location: CLLocationCoordinate2D
    var images: [UIImage] = []
    
    // MARK: - Init
    
    override init() {
        place = nil
        detail = nil
        location = CLLocationCoordinate2D()
    }
    
    init(place: String, detail: String, location: CLLocationCoordinate2D) {
        self.place = place
        self.detail = detail
        self.location = location
    }
    
    // MARK: - Methods
    
    func addImage(image: UIImage) {
        self.images.append(image)
    }
    
    func addComment(comment: String?) {
        if comment != nil {
            self.comments.append(comment!)
        }
    }
}
