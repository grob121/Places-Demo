//
//  CoreDataHelper.swift
//  Places Demo
//
//  Created by Allan Pagdanganan on 05/09/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import CoreData

/**
 This class is a helper to fetch and save coordinates of the user in Core Data.
 
 The fetchCoordinates function fetch the user's coordinates from the managed object and return it on the method call. While save function gets the latitude and longitude coordinates as a parameter and sets its value under the entity of the managed object.
 */
class CoreDataHelper {
    
    func fetchCoordinates() -> Coordinates? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Coordinates>(entityName: "Coordinates")
        
        do {
            let allElementsCount = try managedObjectContext.count(for: fetchRequest)
            fetchRequest.fetchLimit = 1
            fetchRequest.fetchOffset = allElementsCount - 1
            fetchRequest.returnsObjectsAsFaults = false

            let coordinates = try managedObjectContext.fetch(fetchRequest)
            return coordinates[0]
        } catch let error {
            print(error)
            return nil
        }
    }

    func save(latitude: Double, longitude: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Coordinates", in: managedObjectContext)
        
        let coordinates = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        coordinates.setValue(latitude, forKey: "latitude")
        coordinates.setValue(longitude, forKey: "longitude")
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Something went wrong.")
        }
    }
}
