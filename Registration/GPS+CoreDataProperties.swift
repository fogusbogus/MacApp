//
//  GPS+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension GPS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GPS> {
        return NSFetchRequest<GPS>(entityName: "GPS")
    }

    @NSManaged public var easting: Double
    @NSManaged public var northing: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
