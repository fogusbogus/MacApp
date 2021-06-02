//
//  Elector+CoreDataProperties.swift
//  
//
//  Created by Matt Hogg on 02/05/2021.
//
//

import Foundation
import CoreData


extension Elector {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Elector> {
        return NSFetchRequest<Elector>(entityName: "Elector")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var dob: Date?
    @NSManaged public var forenames: String?
    @NSManaged public var middleNames: String?
    @NSManaged public var suffix: String?
    @NSManaged public var surname: String?
    @NSManaged public var title: String?
    @NSManaged public var deceased: Date?
    @NSManaged public var electorNoPrefix: String?
    @NSManaged public var electorNo: Int32
    @NSManaged public var electorNoSuffix: String?
    @NSManaged public var property: Property?
    @NSManaged public var register: Register?
    @NSManaged public var streetOther: Street?
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension Elector {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
