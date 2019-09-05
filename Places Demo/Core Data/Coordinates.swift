//
//  Coordinates.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 05/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//


import Foundation
import CoreData

/**
 This is a custom object representing Coordinates entity in Core Data.
 
 The attributes for this object:
 
 - latitude: The latitude coordinate of the user
 - longitude: The longitude coordinate of the user
 */
@objc(Coordinates)
class Coordinates: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Member", in: managedObjectContext) else {
                fatalError("Failed to decode Member")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 14.5995
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 120.9842
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}


