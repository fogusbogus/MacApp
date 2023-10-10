//
//  Journal+CoreDataProperties.swift
//  Journal-DataModel
//
//  Created by Matt Hogg on 13/05/2022.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: JournalType?

}
