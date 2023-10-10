//
//  Ticket+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import SwiftUI

struct Ticket_UI: View {
	
	struct Options {
		var cornerSize: CGFloat = 25.0
		var borderWidth: CGFloat = 2.0
		var ticketIDPrioritySpacing: CGFloat = 0
		var prioritySymbols: [Int:String] = [
			0:"0.circle.fill",
			1:"1.circle.fill",
			2:"2.circle.fill",
			3:"3.circle.fill",
			4:"4.circle.fill",
			5:"5.circle.fill",
			6:"6.circle.fill",
			7:"7.circle.fill",
			8:"8.circle.fill",
			9:"9.circle.fill"
		]
		var symbolSize: CGFloat = 24
		var foregroundColor: Color?
		var backgroundColor: Color?
		var borderColor: Color?
	}
	
	var ticket: Ticket
	var number: String { ticket.ticketID ?? "XX-9999" }
	var title: String { ticket.name ??  "This is my TODO ticket with some extra information and more information" }
	
	var options = Options()
	
    var body: some View {
		HStack(alignment: .top) {
			VStack(spacing: options.ticketIDPrioritySpacing) {
				Text(number)
					.bold()
				Image(systemName: options.prioritySymbols[Int(ticket.priority)] ?? "")
					.resizable()
					.frame(width:options.symbolSize, height: options.symbolSize)
			}
			Text(title)
				.italic()
			Spacer()
			User_UI(user: ticket.assignedToUser)
		}
		.font(.title)
		.foregroundColor(options.foregroundColor ?? Color("Colors/Ticket/fore"))
		.padding([.leading, .trailing], options.cornerSize)
		.padding([.top, .bottom], 8)
		.background(options.backgroundColor ?? Color("Colors/Ticket/back"))
		.cornerRadius(options.cornerSize)
		.overlay( /// apply a rounded border
			RoundedRectangle(cornerRadius: options.cornerSize)
				.stroke(options.borderColor ?? Color("Colors/Ticket/border"), lineWidth: options.borderWidth)
		)
		.padding(options.borderWidth)
		.draggable(ticket.ticketID!)
    }
}

struct Ticket_UI_Previews: PreviewProvider {
	
	static var ticket: Ticket {
		get {
			PersistenceController.shared.seed()
			return Ticket.getAll().first!
		}
	}
	
    static var previews: some View {
		Ticket_UI(ticket: ticket)
			.frame(width: 500)
			.background(.red)
    }
}
