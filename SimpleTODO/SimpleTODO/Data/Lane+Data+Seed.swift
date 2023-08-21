//
//  Lane+Data+Seed.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import Foundation

extension Lane {
	static func seed() {
		
		let context = PersistenceController.shared.container.viewContext
		
		let category = Category.assert(withName: "DEVTEST") { cat, isNew in
			if isNew {
				cat.code = "XX"
				cat.createdBy = User.admin()
				cat.iteration = 0
			}
			try? context.save()
		}

//		Lane.getAll(includeInvisible: true) { lanes in
//					lanes.forEach { lane in
//						print("Deleting lane - \(lane.name ?? "")")
//						context.delete(lane)
//					}
//					try? context.save()
//				}
		
		Ticket.getAll() { tickets in
			tickets.forEach { ticket in
				ticket.name = ticket.name ?? ticket.brief
			}
			try? context.save()
		}

		Lane.assert(withName: "Dev") { lane, isNew in
			if isNew || lane.ticketsInLane?.count == 0 {
				lane.order = -1
				lane.visible = true
				lane.addToTicketsInLane(Ticket.assert(withTicketID: category.getNewTicket()) { ticket, isNew in
					if isNew {
						ticket.assignedToUser = User.admin()
						ticket.brief = "This is a test ticket"
						ticket.createdBy = User.admin()
					}
				})
				lane.addToTicketsInLane(Ticket.assert(withTicketID: category.getNewTicket()) { ticket, isNew in
					if isNew {
						ticket.assignedToUser = User.admin()
						ticket.brief = "This is another test ticket"
						ticket.createdBy = User.admin()
					}
				})
			}
		}
		
		Lane.assert(withName: "Backlog") { lane in
			if lane.isNew {
				let compareLane = Lane.get(withName: "Dev")
				print("debug")
			}
		}


		Lane.assert(withName: "TODO") { lane, isNew in
			lane.order = 0
			lane.visible = true
		}
		Lane.assert(withName: "In Progress") { lane, isNew in
			lane.order = 1
			lane.visible = true
		}
		Lane.assert(withName: "In Test") { lane, isNew in
			lane.order = 2
			lane.visible = true
		}
		Lane.assert(withName: "Review") { lane, isNew in
			lane.order = 3
			lane.visible = true
		}
		Lane.assert(withName: "Done") { lane, isNew in
			lane.order = 4
			lane.visible = true
		}
		Lane.assert(withName: "Hidden") { lane, isNew in
			lane.order = 5
			lane.visible = false
		}
		try? PersistenceController.shared.container.viewContext.save()
	}
}
