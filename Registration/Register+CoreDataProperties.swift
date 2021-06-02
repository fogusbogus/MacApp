//
//  Register+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension Register {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Register> {
        return NSFetchRequest<Register>(entityName: "Register")
    }

    @NSManaged public var id: Int32
    @NSManaged public var month: Int16
    @NSManaged public var state: Int32
    @NSManaged public var year: Int16

}
