//
//  MetaBased+CoreDataProperties.swift
//  
//
//  Created by Matt Hogg on 12/05/2022.
//
//

import Foundation
import CoreData


extension MetaBased {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetaBased> {
        return NSFetchRequest<MetaBased>(entityName: "MetaBased")
    }

    @NSManaged public var meta: String?

}
