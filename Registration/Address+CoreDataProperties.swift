//
//  Address+CoreDataProperties.swift
//  RegModel
//
//  Created by Matt Hogg on 22/04/2021.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var number: Int32
    @NSManaged public var prefix: String?
    @NSManaged public var suffix: String?
    @NSManaged public var name: String?
    @NSManaged public var nameNumber: Int32
    @NSManaged public var namePrefix: String?
    @NSManaged public var nameSuffix: String?
    @NSManaged public var postCode: String?
    @NSManaged public var address: String?
    @NSManaged public var gps: GPS?

}
