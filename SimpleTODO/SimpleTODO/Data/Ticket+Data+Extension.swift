//
//  Ticket+Data+Extension.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 23/07/2023.
//

import Foundation

extension Ticket {
	static func `get`(withTicketID: String) -> Ticket? {
		Log.return("get ticket with id: \(withTicketID)") {
			Log.function("Ticket::get", parameters: ["withTicketID":withTicketID])
			let context = PersistenceController.shared.container.viewContext
			let fetch = Ticket.fetchRequest()
			fetch.predicate = NSPredicate(format: "ticketID LIKE %@", withTicketID)
			do {
				return try context.fetch(fetch).first
			}
			catch {
				Log.error(error)
			}
			return nil
		} end: { ticket in
			return "<< \(ticket?.myObjectID ?? "nil")"
		}
	}
	
	@discardableResult
	static func getAll(onCollect: (([Ticket]) -> Void)? = nil) -> [Ticket] {
		let context = PersistenceController.shared.container.viewContext
		let fetch = Ticket.fetchRequest()
		do {
			let ret = try context.fetch(fetch)
			onCollect?(ret)
			return ret
		}
		catch {
		}
		onCollect?([])
		return []
	}
	
	typealias CreateOrUpdatePredicate = (ticket: Ticket, isNew: Bool)
	
	@discardableResult
	static func assert(withTicketID: String, onCreateOrUpdate: ((CreateOrUpdatePredicate) -> Void)? = nil) -> Ticket {
		return Log.return("Assert a ticket with the id '\(withTicketID)'") {
			Log.function("Ticket::assert", parameters: ["withTicketID":withTicketID,"onCreateOrUpdate":(onCreateOrUpdate != nil)])
			if let ret = get(withTicketID: withTicketID) {
				onCreateOrUpdate?((ticket: ret, isNew: false))
				return ret
			}
			
			return Log.return("Couldn't find the ticket. Create a new one.") {
				let new = Ticket(context: PersistenceController.shared.container.viewContext)
				new.created = Date.now
				new.ticketID = withTicketID
				onCreateOrUpdate?((ticket: new, isNew: true))
				return new
			}
		} end: { ticket in
			return "<< \(ticket.myObjectID)"
		}
	}
	
	override public func willSave() {
		//A ticket must have a lane.
		Log.process("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))") {
			if currentLane == nil {
				Log.log("There is no current lane, but we must have at least one. Create a backlog lane.")
				currentLane = Lane.assert(withName: "Backlog", onCreateOrUpdate: { update in
					if update.isNew {
						update.lane.visible = false
					}
				})
				currentLane?.addToTicketsInLane(self)
			}
		}
	}
	
	func getTagDeclarations() -> [TagDeclaration] {
		return self.tag?.compactMap {$0 as? TagPool}.asTagDeclarations() ?? []
	}
}
