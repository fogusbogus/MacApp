//
//  Part+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Part {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Part> {
        return NSFetchRequest<Part>(entityName: "Part")
    }

    @NSManaged public var dateOfManufacture: Date?
    @NSManaged public var detail: String?
    @NSManaged public var name: String?
    @NSManaged public var partNumber: String?
    @NSManaged public var category: Category?
    @NSManaged public var manufacturer: Manufacturer?
    @NSManaged public var stockArea: NSSet?

}

// MARK: Generated accessors for stockArea
extension Part {

    @objc(addStockAreaObject:)
    @NSManaged public func addToStockArea(_ value: StockArea)

    @objc(removeStockAreaObject:)
    @NSManaged public func removeFromStockArea(_ value: StockArea)

    @objc(addStockArea:)
    @NSManaged public func addToStockArea(_ values: NSSet)

    @objc(removeStockArea:)
    @NSManaged public func removeFromStockArea(_ values: NSSet)

}

extension Part : Identifiable {

}
