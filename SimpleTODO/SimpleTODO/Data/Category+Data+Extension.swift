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
		return Log.return("get Category with name: '\(withName)'") {
			Log.function("Category::get", parameters: ["withName":withName])
			let context = PersistenceController.shared.container.viewContext
			let fetch = Category.fetchRequest()
			fetch.predicate = NSPredicate(format: "name LIKE %@", withName)
			do {
				return try context.fetch(fetch).first
			}
			catch {
			}
			return nil
		} end: { category in
			return "<< \(category?.myObjectID ?? "nil")"
		}

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
		return Log.return("Assert category with name '\(withName)'") {
			Log.function("Category::assert", parameters: ["withName":withName, "onCreateOrUpdate":(onCreateOrUpdate != nil)])
			if let ret = get(withName: withName) {
				onCreateOrUpdate?((category: ret, isNew: false))
				return ret
			}
			return Log.return("Couldn't find the category. Creating a new one.") {
				let new = Category(context: PersistenceController.shared.container.viewContext)
				new.created = Date.now
				new.name = withName
				onCreateOrUpdate?((category: new, isNew: true))
				return new
			}

		} end: { category in
			return "<< \(category.myObjectID)"
		}

	}
	
	func getNewTicket(save: Bool = true) -> String {
		return Log.return("get a new ticket") {
			Log.function("Cateogry::getNewTicket", parameters: ["save":save])
			self.iteration += 1
			if save {
				try? PersistenceController.shared.container.viewContext.save()
			}
			
			return "\(code ?? "??")-\(iteration)"
		} end: { id in
			return "<< \(id)"
		}

	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))")
	}		
}

extension NSManagedObject {
	func isSaved() -> Bool {
		return !objectID.isTemporaryID
	}
}
