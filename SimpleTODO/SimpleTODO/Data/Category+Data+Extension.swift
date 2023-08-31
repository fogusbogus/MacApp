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
		return Log.return {
			let context = PersistenceController.shared.container.viewContext
			let fetch = Category.fetchRequest()
			fetch.predicate = NSPredicate(format: "name LIKE %@", withName)
			do {
				return try context.fetch(fetch).first
			}
			catch {
			}
			return nil
		} pre: {
			Log.funcParams("Category::get", items: ["withName":withName])
		} post: { category in
			Log.log("<< \(category?.myObjectID ?? "nil")")
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
		return Log.return {
			if let ret = get(withName: withName) {
				onCreateOrUpdate?((category: ret, isNew: false))
				return ret
			}
			return Log.return {
				let new = Category(context: PersistenceController.shared.container.viewContext)
				new.created = Date.now
				new.name = withName
				onCreateOrUpdate?((category: new, isNew: true))
				return new
			} pre: {
				Log.log("Couldn't find the category. Creating a new one.")
			} post: { _ in
				
			}

		} pre: {
			Log.funcParams("Category::assert", items: ["withName":withName, "onCreateOrUpdate":(onCreateOrUpdate != nil)])
		} post: { category in
			Log.log("<< \(category.myObjectID)")
		}

	}
	
	func getNewTicket(save: Bool = true) -> String {
		return Log.return {
			self.iteration += 1
			if save {
				try? PersistenceController.shared.container.viewContext.save()
			}
			
			return "\(code ?? "??")-\(iteration)"
		} pre: {
			Log.funcParams("Cateogry::getNewTicket", items: ["save":save])
		} post: { id in
			Log.log("<< \(id)")
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
