//
//  Category+Data+Extension.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 23/07/2023.
//

import Foundation
import CoreData

extension Category {
	static func `get`(withName: String) -> Category? {
		let context = PersistenceController.shared.container.viewContext
		let fetch = Category.fetchRequest()
		fetch.predicate = NSPredicate(format: "name LIKE %@", withName)
		do {
			return try context.fetch(fetch).first
		}
		catch {
		}
		return nil
	}
	
	typealias CreateOrUpdatePredicate = (category: Category, isNew: Bool)
	
	static func getAll(_ context: NSManagedObjectContext? = nil) -> [Category] {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = Category.fetchRequest()
		do {
			return try context.fetch(fetch)
		}
		catch {
			
		}
		return []
	}
	
	@discardableResult
	static func assert(withName: String, onCreateOrUpdate: ((CreateOrUpdatePredicate) -> Void)? = nil) -> Category {
		if let ret = get(withName: withName) {
			onCreateOrUpdate?((category: ret, isNew: false))
			return ret
		}
		let new = Category(context: PersistenceController.shared.container.viewContext)
		new.created = Date.now
		new.name = withName
		onCreateOrUpdate?((category: new, isNew: true))
		return new
	}
	
	func getNewTicket(save: Bool = true) -> String {
		self.iteration += 1
		if save {
			try? PersistenceController.shared.container.viewContext.save()
		}
		
		return "\(code ?? "??")-\(iteration)"
	}
}

extension NSManagedObject {
	func isSaved() -> Bool {
		return !objectID.isTemporaryID
	}
}
