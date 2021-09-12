//
//  Additional+CoreDataProperties.swift
//  CloudKitStuff
//
//  Created by Matt Hogg on 05/07/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//
//

import Foundation
import CoreData


extension Additional {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Additional> {
        return NSFetchRequest<Additional>(entityName: "Additional")
    }

    @NSManaged public var key: String?
    @NSManaged public var data: String?
    @NSManaged public var event: TwingeEvent?

}
