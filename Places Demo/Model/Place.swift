//
//  Place.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation

/**
 Initializes a place with the provided information to be used in annotation. Codable protocol translates this object to a type that can convert itself into and out of an external representation.
 
 The attributes for this struct:
 
 - position: The coordinates array of the place
 - distance: The distance from the user location
 - title: The name of the place
 - icon: The icon that identify the type of place
 */
struct Place: Codable {
    
    var position: [Double]
    var distance: Int
    var title: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case position
        case distance
        case title
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.position = try valueContainer.decode(Array.self, forKey: CodingKeys.position)
        self.distance = try valueContainer.decode(Int.self, forKey: CodingKeys.distance)
        self.title = try valueContainer.decode(String.self, forKey: CodingKeys.title)
        self.icon = try valueContainer.decode(String.self, forKey: CodingKeys.icon)
    }
}

/**
Map items key to JSON Object
 */
struct Results: Codable {
    
    let items: [Place]
}

/**
 Map results key to JSON Object
 */
struct Json: Codable {
    
    let results: Results
}
