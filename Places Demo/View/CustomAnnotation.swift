//
//  CustomAnnotation.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import MapKit

/**
 Initializes a custom annotation that will be used to display the necessary data on the map
 
 The attributes for this object:
 
 - coordinate: The coordinates of the place
 - title: The title displayed when clicked
 - subtitle: The subtitle displayed when clicked
 - imageUrl: The url of the icon to be used for its image
 */
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
