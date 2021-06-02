//
//  ContactDetail+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension ContactDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactDetail> {
        return NSFetchRequest<ContactDetail>(entityName: "ContactDetail")
    }

    @NSManaged public var contactType: String?
    @NSManaged public var data: String?
    @NSManaged public var searchable: String?

}
