//
//  JournalType+CoreDataProperties.swift
//  Journal-DataModel
//
//  Created by Matt Hogg on 13/05/2022.
//
//

import Foundation
import CoreData


extension JournalType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalType> {
        return NSFetchRequest<JournalType>(entityName: "JournalType")
    }

    @NSManaged public var name: String?
    @NSManaged public var journals: NSSet?

}

// MARK: Generated accessors for journals
extension JournalType {

    @objc(addJournalsObject:)
    @NSManaged public func addToJournals(_ value: Journal)

    @objc(removeJournalsObject:)
    @NSManaged public func removeFromJournals(_ value: Journal)

    @objc(addJournals:)
    @NSManaged public func addToJournals(_ values: NSSet)

    @objc(removeJournals:)
    @NSManaged public func removeFromJournals(_ values: NSSet)

}
