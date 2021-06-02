//
//  Sale+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Sale {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sale> {
        return NSFetchRequest<Sale>(entityName: "Sale")
    }

    @NSManaged public var dateSold: Date?
    @NSManaged public var serialNumber: String?
    @NSManaged public var customer: Contact?
    @NSManaged public var part: Part?
    @NSManaged public var returned: Returns?

}

extension Sale : Identifiable {

}
