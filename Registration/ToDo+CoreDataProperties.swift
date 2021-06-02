//
//  ToDo+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var name: String?
    @NSManaged public var elector: Elector?
    @NSManaged public var property: Property?

}
