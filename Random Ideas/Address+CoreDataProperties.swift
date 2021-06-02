//
//  Address+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var country: String?
    @NSManaged public var postalAddress: String?
    @NSManaged public var type: Int32
    @NSManaged public var zipCode: String?

}

extension Address : Identifiable {
}
