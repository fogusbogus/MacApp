//
//  Entry+CoreDataProperties.swift
//  
//
//  Created by Matt Hogg on 12/05/2022.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var ts: Date?

}
