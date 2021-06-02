//
//  Conversation+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var detail: String?
    @NSManaged public var when: Date?
    @NSManaged public var contact: Contact?
    @NSManaged public var customer: Customer?
    @NSManaged public var manufacturer: Manufacturer?

}

extension Conversation : Identifiable {

}
