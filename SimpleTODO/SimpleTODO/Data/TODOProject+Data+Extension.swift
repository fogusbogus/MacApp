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
		return Log.return("Get project named '\(name)'") {
			Log.function("TODOProject::getNamed", parameters: ["name":name, "context":(context != nil)])
			let context = PersistenceController.shared.container.viewContext
			let fetch = TODOProject.fetchRequest()
			fetch.predicate = NSPredicate(format: "name LIKE %@", name)
			do {
				return try context.fetch(fetch).first
			}
			catch {}
			return nil
		} end: { project in
			return "<< \(project?.myObjectID ?? "nil")"
		}

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
	
	typealias CreateOrUpdatePredicate = (project: TODOProject, isNew: Bool)
	typealias CreateOrUpdateFunction = (CreateOrUpdatePredicate) -> Void
	
	static func create(_ context: NSManagedObjectContext? = nil, onCreateOrUpdate: CreateOrUpdateFunction? = nil) -> TODOProject {
		return Log.return("Create a new TODOProject") {
			Log.function("TODOProject::create", parameters: ["context":(context != nil), "onCreateOrUpdate":(onCreateOrUpdate != nil)])
			let context = context ?? PersistenceController.shared.container.viewContext
			let project = TODOProject(context: context)
			project.createdBy = User.currentUser()
			project.createdTS = .now
			onCreateOrUpdate?((project: project, isNew: true))
			return project
		} end: { project in
			return "<< \(project.myObjectID)"
		}

	}
	
	@discardableResult
	static func assert(name: String, context: NSManagedObjectContext? = nil, onCreateOrUpdate: CreateOrUpdateFunction? = nil) -> TODOProject {
		return Log.return("Assert a TODOProject named '\(name)'") {
			Log.function("TODOProject::assert", parameters: ["name":name, "context":(context != nil), "onCreateOrUpdate":(onCreateOrUpdate != nil)])
			if let ret = getNamed(name, context: context) {
				ret.name = name
				onCreateOrUpdate?((project: ret, isNew: false))
				return ret
			}
			let project = create(context)
			project.name = name
			onCreateOrUpdate?((project: project, isNew: true))
			return project
		} end: { project in
			return "<< \(project.myObjectID)"
		}

	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))")
	}

}

