//
//  TwingeEvent+CoreDataProperties.swift
//  CloudKitStuff
//
//  Created by Matt Hogg on 05/07/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//
//

import Foundation
import CoreData


extension TwingeEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwingeEvent> {
        return NSFetchRequest<TwingeEvent>(entityName: "Event")
    }

    @NSManaged public var title: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var meta: String?
    @NSManaged public var eventGPS: GPS?
    @NSManaged public var twingeItem: NSSet?
    @NSManaged public var twingeAdditional: NSSet?

}

// MARK: Generated accessors for twingeItem
extension TwingeEvent {

    @objc(addTwingeItemObject:)
    @NSManaged public func addToTwingeItem(_ value: Item)

    @objc(removeTwingeItemObject:)
    @NSManaged public func removeFromTwingeItem(_ value: Item)

    @objc(addTwingeItem:)
    @NSManaged public func addToTwingeItem(_ values: NSSet)

    @objc(removeTwingeItem:)
    @NSManaged public func removeFromTwingeItem(_ values: NSSet)

}

// MARK: Generated accessors for twingeAdditional
extension TwingeEvent {

    @objc(addTwingeAdditionalObject:)
    @NSManaged public func addToTwingeAdditional(_ value: Additional)

    @objc(removeTwingeAdditionalObject:)
    @NSManaged public func removeFromTwingeAdditional(_ value: Additional)

    @objc(addTwingeAdditional:)
    @NSManaged public func addToTwingeAdditional(_ values: NSSet)

    @objc(removeTwingeAdditional:)
    @NSManaged public func removeFromTwingeAdditional(_ values: NSSet)

}
