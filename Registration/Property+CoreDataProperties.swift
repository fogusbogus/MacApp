//
//  Property+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension Property {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Property> {
        return NSFetchRequest<Property>(entityName: "Property")
    }

    @NSManaged public var telephone: String?
    @NSManaged public var email: String?
    @NSManaged public var classType: String?
    @NSManaged public var address: Address?
    @NSManaged public var canvassArea: CanvassArea?
    @NSManaged public var electors: NSSet?
    @NSManaged public var register: Register?
    @NSManaged public var street: Street?
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for electors
extension Property {

    @objc(addElectorsObject:)
    @NSManaged public func addToElectors(_ value: Elector)

    @objc(removeElectorsObject:)
    @NSManaged public func removeFromElectors(_ value: Elector)

    @objc(addElectors:)
    @NSManaged public func addToElectors(_ values: NSSet)

    @objc(removeElectors:)
    @NSManaged public func removeFromElectors(_ values: NSSet)

}

// MARK: Generated accessors for todos
extension Property {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
