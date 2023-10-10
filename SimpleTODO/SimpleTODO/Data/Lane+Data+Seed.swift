//
//  Lane+Data+Seed.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import Foundation

extension Lane {
	static func seed() {
		
		Log.process("Lane::seed") {
			let context = PersistenceController.shared.container.viewContext
			
			Log.log("assert the 'DEV Project' project")
			let project = TODOProject.assert(name: "DEV Project") { project, isNew in
				Log.log("Project '\(project.name ?? "")' \(isNew ? "created" : "found")")
			}
			
			Log.log("assert the DEVTEST category")
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
			
			Log.log("Make sure all tickets belong to our project")
			Ticket.getAll() { tickets in
				tickets.forEach { ticket in
					ticket.name = ticket.name ?? ticket.brief
					if ticket.project == nil {
						project.addToTickets(ticket)
					}
				}
				try? context.save()
			}
			
			Log.process("assert the lanes") {
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
			}
			
			try? PersistenceController.shared.container.viewContext.save()
			
			let saveData = Storage_Project.create(project)
			print(saveData)
		}
	}
}
