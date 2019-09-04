//
//  CustomAnnotation.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageUrl: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageUrl: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}
