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
		currentComment = Comment.create(parentComment)
		parentComment.addToReplies(currentComment!)
		try? parentComment.managedObjectContext?.save()
		ui = !ui
	}
	
	func addNewComment(ticket: Ticket) {
		currentComment = Comment.create(ticket)
		
		ticket.addToComments(currentComment!)
		try? ticket.managedObjectContext?.save()
		ui = !ui
	}
	
	var ticket: Ticket?
	var currentComment: Comment?
	
	@Published var ui: Bool = false
	
//	func addNewComment(parentComment: Comment?, ticket: Ticket?) {
//		currentComment = parentComment
//		if let comment = parentComment {
//			currentComment = Comment.create(comment)
//			comment.addToReplies(currentComment!)
//			try? comment.managedObjectContext?.save()
//		}
//		else {
//			if self.ticket != nil {
//				currentComment = Comment.create(self.ticket)
//
//				self.ticket?.addToComments(currentComment!)
//				try? self.ticket?.managedObjectContext?.save()
//			}
//			else {
//				if let ticket = ticket {
//					//We are adding to the ticket, not the comment
//					currentComment = Comment.create(ticket)
//					ticket.addToComments(currentComment!)
//					try? self.ticket?.managedObjectContext?.save()
//				}
//			}
//		}
//		ui = !ui
	//}
	
	func cancelComment(comment: Comment) {
		currentComment = comment.parentComment
		currentComment?.removeFromReplies(comment)
		saveComment(comment: comment)
	}
	
	func saveComment(comment: Comment) {
		try? currentComment?.managedObjectContext?.save()
		currentComment = nil
		ui = !ui
	}
	
	func isEditing(comment: Comment?) -> Bool {
		guard comment != nil && currentComment != nil else { return false }
		
		return currentComment!.objectID == comment!.objectID
	}
	
	func editComment(comment: Comment) {
		currentComment = comment
	}
	
	func removeComment(comment: Comment) {
		if let parent = comment.parentComment {
			parent.removeFromReplies(comment)
			parent.managedObjectContext?.delete(comment)
			try? parent.managedObjectContext?.save()
		}
		else {
			comment.linkedToTicket?.removeFromComments(comment)
			comment.managedObjectContext?.delete(comment)
			try? comment.managedObjectContext?.save()
		}
	}
	
	func isEditingSomething() -> Bool { currentComment != nil }
}
