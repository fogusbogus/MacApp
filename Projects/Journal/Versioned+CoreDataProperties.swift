//
//  Versioned+CoreDataProperties.swift
//  DataLib
//
//  Created by Matt Hogg on 14/05/2022.
//
//

import Foundation
import CoreData


extension Versioned {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Versioned> {
        return NSFetchRequest<Versioned>(entityName: "Versioned")
    }

    @NSManaged public var version: Int32
    @NSManaged public var timestamp: Date?

}

extension Versioned : Identifiable {

}
