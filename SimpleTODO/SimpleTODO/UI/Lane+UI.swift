//
//  Lane+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import SwiftUI

protocol LaneRefreshRequest {
	func laneRequiresRefresh(lane: Lane)
}

struct Lane_UI: View {
	
	struct Options {
		var unknownLaneName: String = "Unknown lane"
		var backgroundColor: Color?
		var backgroundColorWhenTargeted: Color?
		var cornerSize = Constants.cornerSize
		var borderColor: Color?
		var borderWidth = Constants.borderWidth
		var ticketSpacing: CGFloat = 24
		var ticketOptions: Ticket_UI.Options = Ticket_UI.Options()
	}
	
	var lane: Lane
	@State private var isTargeted = false
	var delegate: LaneRefreshRequest?
	
	@ObservedObject var uiRefresh = UIRefresher()
	
	var tickets: [Ticket] {
		get {
			return lane.ticketsInLane?.allObjects.compactMap {$0 as? Ticket}.sorted(by: {$0.priority > $1.priority && $0.ticketID ?? "" > $1.ticketID ?? ""}) ?? []
		}
	}
	
	func getDrag(ticket: Ticket) -> TicketData {
		print("getData")
		let data = TicketData(id: ticket.ticketID!)
		return data
	}
	
	var options = Options()
	
	var body: some View {
		
		VStack {
			VStack(spacing: options.ticketSpacing) {
				Header_UI(text: lane.name ?? options.unknownLaneName)
				ForEach(tickets, id:\.self) { ticket in
					Ticket_UI(ticket: ticket, options: options.ticketOptions)
						.listRowBackground(EmptyView())
						.draggable(getDrag(ticket: ticket))
				}
				HStack {
					Spacer()
				}
				Spacer()
			}
			.scrollContentBackground(.hidden)
		}
		.padding()
		.background(options.backgroundColor ?? Color("Colors/Lane/back" + (isTargeted ? "whentargeted" : "")))
		.cornerRadius(options.cornerSize)
		.overlay(content: {
			RoundedRectangle(cornerRadius: options.cornerSize).stroke(Color("Colors/border"), lineWidth: options.borderWidth)
		})
		.dropDestination(for: String.self) { items, location in
			if let item = items.first {
				if let ticket = Ticket.get(withTicketID: item) {
					let oldLane = ticket.currentLane
					ticket.currentLane?.removeFromTicketsInLane(ticket)
					lane.addToTicketsInLane(ticket)
					try? ticket.managedObjectContext?.save()
					if oldLane != nil {
						delegate?.laneRequiresRefresh(lane: oldLane!)
					}
					uiRefresh.request()
					return true
				}
			}
			return false
		} isTargeted: { isTargeted in
			self.isTargeted = isTargeted
		}
		
	}
}

struct Lane_UI_Previews: PreviewProvider {
	static var lane: Lane {
		get {
			PersistenceController.shared.seed()
			return Lane.getAll().first(where: {$0.ticketsInLane?.count ?? 0 > 0}) ?? Lane()
		}
	}
	static var previews: some View {
		Lane_UI(lane: lane)
			.frame(width:500, height: 500)
			.padding()
	}
}
