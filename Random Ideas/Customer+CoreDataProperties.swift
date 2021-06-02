//
//  Customer+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 21/05/2021.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: String?
    @NSManaged public var salutation: String?
    @NSManaged public var address: Address?

}

// MARK: Generated accessors for address
extension Customer {

    @objc(addAddressObject:)
    @NSManaged public func addToAddress(_ value: Address)

    @objc(removeAddressObject:)
    @NSManaged public func removeFromAddress(_ value: Address)

    @objc(addAddress:)
    @NSManaged public func addToAddress(_ values: NSSet)

    @objc(removeAddress:)
    @NSManaged public func removeFromAddress(_ values: NSSet)

}

extension Customer : Identifiable {

}
