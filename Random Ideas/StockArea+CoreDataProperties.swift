//
//  StockArea+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension StockArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockArea> {
        return NSFetchRequest<StockArea>(entityName: "StockArea")
    }

    @NSManaged public var location: String?
    @NSManaged public var reorderThreshold: Int32
    @NSManaged public var stockCount: Int32
    @NSManaged public var part: Part?

}

extension StockArea : Identifiable {

}
