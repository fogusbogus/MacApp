//
//  SimpleTODOApp.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import SwiftUI

@main
struct SimpleTODOApp: App {
	
	init() {
		//Log.devMode = true
	}
	
    let persistenceController = PersistenceController.shared

	var ticket: Ticket {
		get {
			return Ticket.getAll().first ?? Ticket()
		}
	}
	
	var delegate = StandardTicketCommentHandler()
	@ObservedObject var ui = UIRefresher()
	
	var lanes: [Lane] {
		get {
			return Lane.getAll().sorted(by: {$0.order < $1.order})
		}
	}
	
	var comment: Comment? {
		get {
			return Comment.getAll().first
		}
	}
	
	@ObservedObject var commentDelegate = CommentHandler()
	
    var body: some Scene {
        WindowGroup {
//            Board_UI(lanes: lanes)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//				.onAppear {
//					persistenceController.seed()
//				}
//				.padding()
			ScrollView(.vertical, showsIndicators: true) {
				TicketComment_UI(ticket: ticket, delegate: delegate, ui: ui)
					.padding()
			}
			.onAppear {
				//PersistenceController.shared.DeleteAllComments()
				Log.process("onAppear") {
					PersistenceController.shared.seed()
				}
			}
        }
    }
}
