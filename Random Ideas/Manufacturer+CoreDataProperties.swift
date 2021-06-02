//
//  Manufacturer+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Manufacturer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Manufacturer> {
        return NSFetchRequest<Manufacturer>(entityName: "Manufacturer")
    }

    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var contact: NSSet?

}

// MARK: Generated accessors for contact
extension Manufacturer {

    @objc(addContactObject:)
    @NSManaged public func addToContact(_ value: Contact)

    @objc(removeContactObject:)
    @NSManaged public func removeFromContact(_ value: Contact)

    @objc(addContact:)
    @NSManaged public func addToContact(_ values: NSSet)

    @objc(removeContact:)
    @NSManaged public func removeFromContact(_ values: NSSet)

}

extension Manufacturer : Identifiable {

}
