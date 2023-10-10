//
//  TicketComment+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 17/08/2023.
//

import SwiftUI

/*
 Comments: (Add)
 
 No comments
 
 or
 
 Comments (Add):
 
 Replied on 1 Jan 2023 @ 11:43 by user
 
 [This is my comments]
 
 (Reply)
 
 -- replies and other comments
 
 
 */

protocol TicketCommentDelegate {
	func addCommentToTicket(ticket: Ticket)
	func addReplyToComment(comment: Comment)
	func markCommentOrReplyAsRemoved(comment: Comment)
	func saveComment(comment: Comment)
	func cancelEdit(comment: Comment)
	func isEditingComment(comment: Comment) -> Bool
	func inEditMode() -> Bool
	func maxLevel() -> Int
	func minLevel() -> Int
	func toggleReveal()
	func editComment(comment: Comment)
}

struct TicketCommentItem_UI: View {
	var comment: Comment
	var delegate: TicketCommentDelegate?
	
	@ObservedObject var ui = UIRefresher()
	
	@State var text: String = ""
	@State private var deleteItem = false
	
	private var inEditMode : Bool {
		get {
			if let delegate = delegate {
				return delegate.inEditMode()
			}
			return false
		}
	}
	
	var level: Int {
		get {
			var ret = 0
			var iteration = comment
			while iteration.parentComment != nil {
				ret += 1
				iteration = iteration.parentComment!
			}
			return ret
		}
	}
	
	var headingTitle: String {
		get {
			if comment.parentComment != nil {
				return "Replied"
			}
			return "Commented"
		}
	}
	
	func replies() -> [Comment] {
		guard comment.replies != nil else { return [] }
		guard !comment.removed else { return [] }
		
		return comment.replies!.allObjects.map {$0 as! Comment} //.filter {!$0.removed}
	}
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text("\(headingTitle) on ") +
				Text(comment.createdTS.getFormatted()).italic() +
				Text(" by ") +
				Text(comment.authorName).bold()	//TODO: Make clickable
				Divider()
				if comment.removed {
					Text("Comment removed by user").italic().opacity(0.5)
				}
				else {
					if let del = delegate, !del.isEditingComment(comment: comment) {
						Text(comment.text ?? "").italic().padding()
					}
					else {
						//We are editing, so provide something to edit
						VStack(alignment:.leading, spacing: 24) {
							TextEditor(text: $text).frame(height: 96)
							HStack(spacing: 36) {
								Button {
									comment.text = text
									delegate?.saveComment(comment: comment)
									text = ""
									ui.request()
							} label: {
									Text("Save")
								}
								.buttonStyle(StandardButton(background: .blue))
								Button {
									if comment.text?.count ?? 0 > 0 {
										delegate?.cancelEdit(comment: comment)
										text = ""
									}
									else {
										delegate?.markCommentOrReplyAsRemoved(comment: comment)
										text = ""
									}
									ui.request()
							} label: {
									Text("Cancel")
								}
								.buttonStyle(StandardButton(background: .red))
							}
						}
					}
				}
				if !comment.removed && !inEditMode {
					HStack(spacing: 24) {
						Button {
							delegate?.addReplyToComment(comment: comment)
							ui.request()
						} label: {
							Text("Reply")
						}
						.buttonStyle(StandardButton())
						if comment.author?.isCurrentUserOrAdmin() ?? true {
							Button {
								text = comment.text ?? ""
								delegate?.editComment(comment: comment)
								ui.request()
							} label: {
								Text("Edit")
							}
							.buttonStyle(StandardButton(background: .green))

							Button(role: .destructive) {
								deleteItem = true
							} label: {
								Text("Delete")
							}
							.buttonStyle(StandardButton(background: .red))
							.confirmationDialog("Are you sure you want to remove this comment?", isPresented: $deleteItem) {
								Button {
									delegate?.markCommentOrReplyAsRemoved(comment: comment)
									ui.request()
								} label: {
									Text("Delete")
								}
								Button(role: .cancel) {
									
								} label: {
									Text("Cancel")
								}
							}

						}
					}
				}
				
				//Now the rest of our comments
				ForEach(replies(), id:\.self) { reply in
					TicketCommentItem_UI(comment: reply, delegate: delegate, ui: ui)
						.padding()
						.padding(.leading)
				}
			}
			Spacer()
		}
	}
}

class StandardTicketCommentHandler : TicketCommentDelegate {
	private var currentComment: Comment? = nil {
		didSet {
			if let comment = currentComment {
				Log.paramList(["currentComment::set":comment.myObjectID])
			}
			else {
				Log.paramList(["currentComment::set":"nil"])
			}
		}
	}
	private var maximumLevel = Int.max
	private var minimumLevel = Int.max
	
	func addCommentToTicket(ticket: Ticket) {
		Log.function("STCH::addCommentToTicket", parameters: ["ticket":ticket.myObjectID])
		Log.process("...") {
			let comment = Comment.create(ticket)
			self.currentComment = comment
			comment.author = User.currentUser()
			comment.created = .now
			ticket.addToComments(comment)
			try? ticket.managedObjectContext?.save()
		}
	}
	
	func addReplyToComment(comment: Comment) {
		Log.function("STCH::addReplyToComment", parameters: ["comment":comment.myObjectID])
		Log.process("...") {
			let newComment = Comment.create(comment)
			self.currentComment = newComment
			newComment.author = User.currentUser()
			newComment.created = .now
			comment.addToReplies(newComment)
			try? comment.managedObjectContext?.save()
		}
	}
	
	func markCommentOrReplyAsRemoved(comment: Comment) {
		Log.function("STCH::markCommentOrReplyAsRemoved", parameters: ["comment":comment.myObjectID])
		Log.process("...") {
			if comment.isSaved() && comment.text?.count ?? 0 > 0 {
				comment.remove()
			}
			else {
				comment.managedObjectContext?.delete(comment)
				comment.parentComment?.removeFromReplies(comment)
				comment.linkedToTicket?.removeFromComments(comment)
			}
			try? comment.managedObjectContext?.save()
			currentComment = nil
		}
	}
	
	func saveComment(comment: Comment) {
		Log.function("STCH::saveComment", parameters: ["comment":comment.myObjectID])
		Log.process("...") {
			try? comment.managedObjectContext?.save()
			currentComment = nil
		}
	}
	
	func isEditingComment(comment: Comment) -> Bool {
		return currentComment?.objectID == comment.objectID
	}
	
	func inEditMode() -> Bool {
		return currentComment != nil
	}
	
	func maxLevel() -> Int {
		return maximumLevel
	}
	
	func minLevel() -> Int {
		minimumLevel
	}
	
	func toggleReveal() {
		
	}
	
	func cancelEdit(comment: Comment) {
		Log.function("STCH::cancelEdit", parameters: ["comment":comment.myObjectID])
		Log.process("...") {
			currentComment = nil
		}
	}
	
	func editComment(comment: Comment) {
		Log.function("STCH::editComment", parameters: ["comment":comment.myObjectID])
		Log.process("...") {
			currentComment = comment
		}
	}
	
}

struct TicketComment_UI: View {
	
	var ticket: Ticket
	var delegate: TicketCommentDelegate?
	
	@ObservedObject var ui = UIRefresher()

	var replyTo: Comment?
	
	private var inEditMode : Bool {
		get {
			if let delegate = delegate {
				return delegate.inEditMode()
			}
			return false
		}
	}

	var hasNoComments: Bool { ticket.comments?.count ?? 0 == 0}
	
	func comments() -> [Comment] {
		guard ticket.comments != nil else { return [] }
		
		return ticket.comments!.allObjects.map {$0 as! Comment}
	}
	
    var body: some View {
		VStack {
			///Headline
			HStack(spacing: 24) {
				Text("Comments")
					.font(.title2)
				if !hasNoComments {
					Button {
						//Add a comment to the ticket
						delegate?.addCommentToTicket(ticket: ticket)
						ui.request()
					} label: {
						Text("Add")
					}
					.buttonStyle(StandardButton())
					.hidden(inEditMode)
				}
				Spacer()
			}
			if hasNoComments {
				Divider()
				HStack(spacing: 24) {
					Text("No comments. Be the first to add one.")
						.italic()
						.opacity(0.5)
					Button {
						//Add a comment to the ticket
						delegate?.addCommentToTicket(ticket: ticket)
						ui.request()
					} label: {
						Text("Add")
					}
					.buttonStyle(StandardButton())
					.disabled(delegate?.inEditMode() ?? false)
					Spacer()
				}
				.padding()
			}
			else {
				//We need to add our comments, even the ones that are marked as removed
				ForEach(comments(), id:\.self) { comment in
					Divider()
					TicketCommentItem_UI(comment: comment, delegate: delegate, ui: ui)
				}
			}
		}
    }
}

struct TicketComment_UI_Previews: PreviewProvider {
	
	static var ui = UIRefresher()
	
	static var delegate = StandardTicketCommentHandler()
	
	static var ticket: Ticket {
		get {
			return Ticket.getAll().first ?? Ticket()
		}
	}
    static var previews: some View {
		ScrollView(.vertical) {
			TicketComment_UI(ticket: ticket, delegate: delegate, ui: ui)
				.padding()
		}
    }
}

import CoreData

extension NSManagedObject {
	var myObjectID: String {
		get {
			return String(describing: objectID).split(whereSeparator: {$0 == " "}).first! + (objectID.isTemporaryID ? " (T)" : "")
		}
	}
}

extension Comment {
	override public func didSave() {
		Log.paramList(["Comment::save":self.myObjectID])
	}
}

extension Ticket {
	override public func didSave() {
		Log.paramList(["Ticket::save":self.myObjectID])
	}
}
