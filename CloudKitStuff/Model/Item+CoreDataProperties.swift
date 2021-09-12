//
//  Item+CoreDataProperties.swift
//  CloudKitStuff
//
//  Created by Matt Hogg on 05/07/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var area: String?
    @NSManaged public var painLevel: Int16
    @NSManaged public var event: TwingeEvent?

}
