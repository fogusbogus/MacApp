//
//  TODOProject+Data+Extension.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 21/08/2023.
//

import Foundation

import Foundation
import CoreData

extension TODOProject {
	static func getNamed(_ name: String, context: NSManagedObjectContext? = nil) -> TODOProject? {
		let context = PersistenceController.shared.container.viewContext
		let fetch = TODOProject.fetchRequest()
		fetch.predicate = NSPredicate(format: "name LIKE %@", name)
		do {
			return try context.fetch(fetch).first
		}
		catch {}
		return nil
	}
	
	static func getAll(context: NSManagedObjectContext? = nil) -> [TODOProject] {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = TODOProject.fetchRequest()
		do {
			return try context.fetch(fetch)
		}
		catch {}
		return []
	}
	
	func allTickets() -> [Ticket] {
		return self.tickets?.allObjects.map {$0 as! Ticket} ?? []
	}
	
	static func create(_ context: NSManagedObjectContext? = nil, onCreateOrUpdate: ((TODOProject) -> Void)? = nil) -> TODOProject {
		let context = context ?? PersistenceController.shared.container.viewContext
		let project = TODOProject(context: context)
		project.createdBy = User.currentUser()
		project.createdTS = .now
		onCreateOrUpdate?(project)
		return project
	}
	
	@discardableResult
	static func assert(name: String, context: NSManagedObjectContext? = nil, onCreateOrUpdate: ((TODOProject) -> Void)? = nil) -> TODOProject {
		let project = getNamed(name, context: context) ?? create(context)
		project.name = name
		onCreateOrUpdate?(project)
		return project
	}
}

