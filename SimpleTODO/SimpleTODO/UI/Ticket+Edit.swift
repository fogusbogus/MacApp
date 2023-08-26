//
//  Ticket+Edit.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 25/07/2023.
//

import SwiftUI

struct Ticket_Data {
	
	var name: String
	var ticketID: String
	var brief: String
	var acceptanceCriteria: String
	var ticket: Ticket
	var selectedLane: String
	var assignee: String
	var priority: Int32
	private var oldHash: Int
	
	init(ticket: Ticket) {
		self.name = ticket.name ?? ""
		self.ticketID = ticket.ticketID ?? "??-?"
		self.brief = ticket.brief ?? ""
		self.acceptanceCriteria = ticket.acceptanceCriteria ?? ""
		self.ticket = ticket
		self.selectedLane = ticket.currentLane?.name ?? ""
		self.assignee = ticket.assignedToUser?.name ?? ""
		self.priority = ticket.priority
		self.oldHash = 0
		self.oldHash = getHash()
	}
	
	var hasChanges: Bool { oldHash != getHash() }
	
	private func getHash() -> Int {
		var hasher = Hasher()
		hasher.combine(name)
		hasher.combine(ticketID)
		hasher.combine(brief)
		hasher.combine(acceptanceCriteria)
		hasher.combine(selectedLane)
		hasher.combine(assignee)
		hasher.combine(priority)
		return hasher.finalize()
	}
}

struct PrioritySelect: View {
	var icon: String
	var angle: Int = 0
	var name: String
	var color: Color
	
	var body: some View {
		HStack {
			Image(systemName: icon)
				.rotationEffect(Angle(degrees: Double(angle)))
				.foregroundColor(color)
				.frame(width: 48)
			Text(name)
		}
	}
}

struct TicketDetails : View {
	
	@State var ticketData: Ticket_Data
	
	var body: some View {
		Section("Details") {
			Form {
				Picker("Assignee", selection: $ticketData.assignee) {
					ForEach(User.getAll(), id:\.self) { user in
						Text(user.name ?? "")
					}
				}
				LabeledContent("Reporter", value: ticketData.ticket.createdBy?.name ?? "")
				LabeledContent("Tags") {
					//TODO
				}
				Picker("Priority", selection: $ticketData.priority) {
					PrioritySelect(icon: "0.circle.fill", angle: 90, name: "Very Low", color: .blue).tag(0)
					PrioritySelect(icon: "1.circle.fill", angle: 90, name: "Low", color: .blue).tag(1)
					PrioritySelect(icon: "2.circle.fill", name: "Medium", color: .yellow).tag(2)
					PrioritySelect(icon: "3.circle.fill", angle: 90, name: "High", color: .red).tag(3)
					PrioritySelect(icon: "4.circle.fill", angle: 90, name: "Very High", color: .red).tag(4)
					PrioritySelect(icon: "5.circle.fill", name: "Critical", color: .red).tag(5)
				}
			}
		}
	}
}

struct Ticket_Edit: View {
	
	@State var ticket: Ticket_Data
	var delegate = StandardTicketCommentHandler()
	var ui = UIRefresher()
	
	private var lanes: [String] {
		get {
			var ret : [String] = [""]
			var visibleLanes = Lane.getAll(includeInvisible: false)
			visibleLanes.sort(by: {$0.order < $1.order})
			ret.append(contentsOf: visibleLanes.map({$0.name ?? ""}))
			return ret
		}
	}
	
    var body: some View {
        //Heading - editable
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text(ticket.ticketID)
					.opacity(0.70)
				TextField("Title", text: $ticket.name)
				Text(ticket.ticket.isSaved() ? "Edit" : "New")
			}
			.font(.title)
			Divider()
			HStack(alignment: .top) {
				ScrollView(.vertical) {
					Group {
						HStack {
							Text("Description")
								.font(.headline)
							Spacer()
						}
						TextEditor(text: $ticket.brief)
							.frame(height: 200)
							.padding(.leading)
					}
					.padding(.top)
					Group {
						HStack {
							Text("Acceptance Criteria")
								.font(.headline)
							Spacer()
						}
						TextEditor(text: $ticket.acceptanceCriteria)
							.frame(height: 200)
							.padding(.leading)
					}
					.padding(.top)
				}
				Divider()
				VStack(alignment: .leading, content: {
						Picker("Lane", selection: $ticket.selectedLane) {
							ForEach(Lane.getAll(includeInvisible: true), id:\.self) { lane in
								Text(lane.name ?? "")
									.tag(lane.id)
									.bold(lane.visible)
							}
						}
					Divider()
						TicketDetails(ticketData: ticket)
				})
//				.frame(width: 200)
			}
			Divider()
			Group {	//Button area
				HStack {
					Button("Save") {
						
					}
					.buttonStyle(StandardButton())
					.disabled(ticket.hasChanges)
					Button("Cancel") {
						
					}
					.buttonStyle(StandardButton(background: .red))
				}
			}
			Divider()
			TicketComment_UI(ticket: ticket.ticket, delegate: delegate, ui: ui)
		}
    }
}

struct Ticket_Edit_Previews: PreviewProvider {
	
	static var ticket: Ticket {
		get {
			PersistenceController.shared.seed()
			return Ticket.getAll().first ?? Ticket()
		}
	}
	
    static var previews: some View {
		ZStack {
			RoundedRectangle(cornerRadius: Constants.cornerSize).stroke(Color("Colors/border"), lineWidth: Constants.borderWidth)
				.background(Color("Colors/Ticket/Edit/back"))
				.cornerRadius(Constants.cornerSize)
			ScrollView(.vertical) {
				Ticket_Edit(ticket: Ticket_Data(ticket: ticket))
					.padding()
			}
		}
		.padding()
    }
}
