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
		let ret = Comment(context: template?.managedObjectContext ?? PersistenceController.shared.container.viewContext)
		ret.created = .now
		ret.author = User.admin()
		ret.text = ""
		return ret
	}
	
	func remove() {
		removedBy = removedBy ?? User.currentUser()
		removed = true
		whenRemoved = whenRemoved ?? .now
		try? managedObjectContext?.save()
	}
}


