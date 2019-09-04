//
//  Place.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 03/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import Foundation

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

struct Results: Codable {
    
    let items: [Place]
}

struct Json: Codable {
    
    let results: Results
}
