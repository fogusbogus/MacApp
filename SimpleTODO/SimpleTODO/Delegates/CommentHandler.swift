//
//  CommentHandler.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 15/08/2023.
//

import Foundation

protocol CommentDelegate {
	/// Add a reply to a comment
	/// - Parameters:
	///   - parentComment: the parent comment
	func addNewComment(parentComment: Comment)
	/// Add a reply to a ticket
	/// - Parameter ticket: the parent ticket

	func addNewComment(ticket: Ticket)
	
	/// Cancel a comment (effective deletion or restoration)
	/// - Parameter comment: The comment
	func cancelComment(comment: Comment)
	/// Save the comment (cement it by saving it)
	/// - Parameter comment: The comment to save
	func saveComment(comment: Comment)
	/// Is this the current comment being edited?
	/// - Parameter comment: The comment
	/// - Returns: true if the comment marked as editing
	func isEditing(comment: Comment?) -> Bool
	/// Mark the comment as editing
	/// - Parameter comment: The comment
	func editComment(comment: Comment)
	/// Are we editing a comment?
	/// - Returns: true if any comment is being edited
	func isEditingSomething() -> Bool
	/// Delete a comment
	/// - Parameter comment: The comment to delete
	func removeComment(comment: Comment)
}


class CommentHandler: CommentDelegate, ObservableObject {
	func addNewComment(parentComment: Comment) {
		Log.funcParams("CH::addNewComment(Comment)", items: ["parentComment":parentComment.objectID])
		Log.process("...") {
			currentComment = Comment.create(parentComment)
			parentComment.addToReplies(currentComment!)
			try? parentComment.managedObjectContext?.save()
			ui = !ui
		}
	}
	
	func addNewComment(ticket: Ticket) {
		Log.funcParams("CH::addNewComment(Ticket)", items: ["ticket":ticket.objectID])
		Log.process("...") {
			currentComment = Comment.create(ticket)
			
			ticket.addToComments(currentComment!)
			try? ticket.managedObjectContext?.save()
			ui = !ui
		}
	}
	
	var ticket: Ticket?
	var currentComment: Comment? {
		didSet {
			Log.paramList(["currentComment::set":currentComment?.objectID ?? "nil"])
		}
	}
	
	@Published var ui: Bool = false
	

	func cancelComment(comment: Comment) {
		Log.funcParams("CH::cancelComment", items: ["comment":comment.objectID])
		Log.process("...") {
			currentComment = comment.parentComment
			currentComment?.removeFromReplies(comment)
			saveComment(comment: comment)
		}
	}
	
	func saveComment(comment: Comment) {
		Log.funcParams("CH::saveComment", items: ["comment":comment.objectID])
		Log.process("...") {
			try? currentComment?.managedObjectContext?.save()
			currentComment = nil
			ui = !ui
		}
	}
	
	func isEditing(comment: Comment?) -> Bool {
		guard comment != nil && currentComment != nil else { return false }
		
		return currentComment!.objectID == comment!.objectID
	}
	
	func editComment(comment: Comment) {
		Log.funcParams("CH::editComment", items: ["comment":comment.objectID])
		Log.process("...") {
			currentComment = comment
		}
	}
	
	func removeComment(comment: Comment) {
		Log.funcParams("CH::editComment", items: ["comment":comment.objectID])
		Log.process("...") {
			if let parent = comment.parentComment {
				Log.process("Remove from a parent comment") {
					parent.removeFromReplies(comment)
					parent.managedObjectContext?.delete(comment)
					try? parent.managedObjectContext?.save()
				}
			}
			else {
				Log.process("Remove from the ticket") {
					comment.linkedToTicket?.removeFromComments(comment)
					comment.managedObjectContext?.delete(comment)
					try? comment.managedObjectContext?.save()
				}
			}
		}
	}
	
	func isEditingSomething() -> Bool { currentComment != nil }
}
