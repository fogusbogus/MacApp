//
//  GPS+CoreDataProperties.swift
//  CloudKitStuff
//
//  Created by Matt Hogg on 05/07/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//
//

import Foundation
import CoreData


extension GPS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GPS> {
        return NSFetchRequest<GPS>(entityName: "GPS")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var event: TwingeEvent?

}
