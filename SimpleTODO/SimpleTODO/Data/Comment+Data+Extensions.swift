//
//  Comment+Data+Extensions.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 07/08/2023.
//

import Foundation
import CoreData

extension Comment {
	
	var createdTS: Date { created ?? .now }
	var authorName: String { author?.name ?? "Unknown"}
	
	static func getAll() -> [Comment] {
		let context = PersistenceController.shared.container.viewContext
		let fetch = Comment.fetchRequest()
		do {
			let ret = try context.fetch(fetch)
			return ret.sorted(by: {$0.createdTS < $1.createdTS})
		}
		catch {}
		return []
	}
	
	static func create(_ template: NSManagedObject? = nil) -> Comment {
		return Log.return("Create a comment") {
			Log.function("Comment::create()", parameters: ["template":template?.myObjectID ?? ""])

			let ret = Comment(context: template?.managedObjectContext ?? PersistenceController.shared.container.viewContext)
			ret.created = .now
			ret.author = User.admin()
			ret.text = ""
			return ret
			
		} end: { ret in
			return "<< \(ret.myObjectID)"
		}

	}
	
	func remove() {
		Log.process("Comment::remove()") {
			removedBy = removedBy ?? User.currentUser()
			removed = true
			whenRemoved = whenRemoved ?? .now
			try? managedObjectContext?.save()
		}
	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(text ?? "")' (\(myObjectID))")
	}

}


