//
//  Enquiry+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Enquiry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Enquiry> {
        return NSFetchRequest<Enquiry>(entityName: "Enquiry")
    }

    @NSManaged public var keywords: String?
    @NSManaged public var contact: Customer?
    @NSManaged public var conversation: NSSet?

}

// MARK: Generated accessors for conversation
extension Enquiry {

    @objc(addConversationObject:)
    @NSManaged public func addToConversation(_ value: Conversation)

    @objc(removeConversationObject:)
    @NSManaged public func removeFromConversation(_ value: Conversation)

    @objc(addConversation:)
    @NSManaged public func addToConversation(_ values: NSSet)

    @objc(removeConversation:)
    @NSManaged public func removeFromConversation(_ values: NSSet)

}

extension Enquiry : Identifiable {

}
