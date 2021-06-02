//
//  Category+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?

}

extension Category : Identifiable {

}
