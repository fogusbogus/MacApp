//
//  Returns+CoreDataProperties.swift
//  DataModel
//
//  Created by Matt Hogg on 19/05/2021.
//
//

import Foundation
import CoreData


extension Returns {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Returns> {
        return NSFetchRequest<Returns>(entityName: "Returns")
    }

    @NSManaged public var reason: String?
    @NSManaged public var refundAmount: NSDecimalNumber?
    @NSManaged public var refundDate: Date?
    @NSManaged public var conversation: NSSet?
    @NSManaged public var refundee: NSSet?

}

// MARK: Generated accessors for conversation
extension Returns {

    @objc(addConversationObject:)
    @NSManaged public func addToConversation(_ value: Conversation)

    @objc(removeConversationObject:)
    @NSManaged public func removeFromConversation(_ value: Conversation)

    @objc(addConversation:)
    @NSManaged public func addToConversation(_ values: NSSet)

    @objc(removeConversation:)
    @NSManaged public func removeFromConversation(_ values: NSSet)

}

// MARK: Generated accessors for refundee
extension Returns {

    @objc(addRefundeeObject:)
    @NSManaged public func addToRefundee(_ value: Contact)

    @objc(removeRefundeeObject:)
    @NSManaged public func removeFromRefundee(_ value: Contact)

    @objc(addRefundee:)
    @NSManaged public func addToRefundee(_ values: NSSet)

    @objc(removeRefundee:)
    @NSManaged public func removeFromRefundee(_ values: NSSet)

}

extension Returns : Identifiable {

}
