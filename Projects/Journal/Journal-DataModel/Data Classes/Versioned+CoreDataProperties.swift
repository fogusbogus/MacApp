//
//  Versioned+CoreDataProperties.swift
//  Journal-DataModel
//
//  Created by Matt Hogg on 13/05/2022.
//
//

import Foundation
import CoreData


extension Versioned {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Versioned> {
        return NSFetchRequest<Versioned>(entityName: "Versioned")
    }

    @NSManaged public var version: Int32

}

extension Versioned : Identifiable {

}
