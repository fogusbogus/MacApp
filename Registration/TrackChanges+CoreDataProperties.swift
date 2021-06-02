//
//  TrackChanges+CoreDataProperties.swift
//  
//
//  Created by Matt Hogg on 02/05/2021.
//
//

import Foundation
import CoreData


extension TrackChanges {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackChanges> {
        return NSFetchRequest<TrackChanges>(entityName: "TrackChanges")
    }

    @NSManaged public var createdBy: String?
    @NSManaged public var createdTS: Date?
    @NSManaged public var deletedBy: String?
    @NSManaged public var deletedTS: Date?
    @NSManaged public var modifiedBy: String?
    @NSManaged public var modifiedTS: Date?

}
