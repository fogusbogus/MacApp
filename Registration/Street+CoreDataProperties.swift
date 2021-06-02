//
//  Street+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension Street {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Street> {
        return NSFetchRequest<Street>(entityName: "Street")
    }

    @NSManaged public var name: String?
    @NSManaged public var postCode: String?
    @NSManaged public var otherElectors: NSSet?
    @NSManaged public var properties: NSSet?
    @NSManaged public var register: Register?

}

// MARK: Generated accessors for otherElectors
extension Street {

    @objc(addOtherElectorsObject:)
    @NSManaged public func addToOtherElectors(_ value: Elector)

    @objc(removeOtherElectorsObject:)
    @NSManaged public func removeFromOtherElectors(_ value: Elector)

    @objc(addOtherElectors:)
    @NSManaged public func addToOtherElectors(_ values: NSSet)

    @objc(removeOtherElectors:)
    @NSManaged public func removeFromOtherElectors(_ values: NSSet)

}

// MARK: Generated accessors for properties
extension Street {

    @objc(addPropertiesObject:)
    @NSManaged public func addToProperties(_ value: Property)

    @objc(removePropertiesObject:)
    @NSManaged public func removeFromProperties(_ value: Property)

    @objc(addProperties:)
    @NSManaged public func addToProperties(_ values: NSSet)

    @objc(removeProperties:)
    @NSManaged public func removeFromProperties(_ values: NSSet)

}
