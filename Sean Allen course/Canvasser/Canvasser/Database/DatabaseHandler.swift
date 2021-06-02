//
//  DatabaseHandler.swift
//  Canvasser
//
//  Created by Matt Hogg on 30/01/2021.
//

import Foundation
import CoreData

struct CoreDataManager {
	static var shared = CoreDataManager()
	
	lazy var persistentContainer : NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Canvasser")
		container.loadPersistentStores { (desc, error) in
			if let error = error {
				fatalError("Loading of store failed \(error)")
			}
		}
		return container
	}()
	
	func setup() {
		
		
		let streets : [Street]? = CoreDataManager.fetch()
		
//		streets?.forEach({ (st) in
//			CoreDataManager.delete(item: st)
//		})
//		CoreDataManager.save()
//
//		Databases.shared.Register.processMultiRow(rowHandler: { (rowST) in
//			let st : Street? = CoreDataManager.create(name: rowST.get("name", ""))
//			Databases.shared.Register.processMultiRow(rowHandler: { (rowPR) in
//				if let pr : Property = CoreDataManager.create(name: rowPR.get("name", "")) {
//					st?.addToProperties(pr)
//					Databases.shared.Register.processMultiRow(rowHandler: { (rowEL) in
//						if let el : Elector = CoreDataManager.create(name: rowEL.get("displayname", "")) {
//							pr.addToElectors(el)
//							el.forename = rowEL.get("forename", "")
//							el.surname = rowEL.get("surname", "")
//							el.middleNames = rowEL.get("middleName", "")
//						}
//					}, "SELECT * FROM Elector WHERE PID = ?", rowPR.get("id", -1))
//				}
//			}, "SELECT * FROM Property WHERE SID = ?", rowST.get("id", -1))
//		}, "SELECT * FROM Street")
//		CoreDataManager.save()
		
		/*
		if streets == nil || streets?.count == 0 {
			let st : Street? = CoreDataManager.create(name: "Berkeley Close")
			if let pr : Property = CoreDataManager.create(name: "11") {
				st?.addToProperties(pr)
				if let el : Elector = CoreDataManager.create(name: "Matthew Hogg") {
					pr.addToElectors(el)
				}
				if let el : Elector = CoreDataManager.create(name: "Laurie Hogg") {
					pr.addToElectors(el)
				}
				if let el : Elector = CoreDataManager.create(name: "Georgia Hogg") {
					pr.addToElectors(el)
				}
			}
			CoreDataManager.save()
		}
*/
	}
}

extension Street {
	func getProperties() -> [Property] {
		var ret : [Property] = []
		self.properties?.forEach({ (pr) in
			if let prop = pr as? Property {
				ret.append(prop)
			}
		})
		return ret
	}
}

extension Property {
	func getElectors() -> [Elector] {
		var ret : [Elector] = []
		self.electors?.forEach({ (el) in
			if let elec = el as? Elector {
				ret.append(elec)
			}
		})
		return ret
	}
}

extension Array where Element == NSManagedObject {
}

//Electors
extension CoreDataManager {
	@discardableResult
	static func create(name: String) -> Elector? {
		let ret : Elector? = create()
		ret?.name = name
		return ret
	}
	@discardableResult
	static func create(name: String) -> Property? {
		let ret : Property? = create()
		ret?.name = name
		return ret
	}
	@discardableResult
	static func create(name: String) -> Street? {
		let ret : Street? = create()
		ret?.name = name
		return ret
	}
	@discardableResult
	static func create(name: String) -> Action? {
		let ret : Action? = create()
		ret?.name = name
		return ret
	}
	@discardableResult
	static func create(name: String) -> TodoAction? {
		let ret : TodoAction? = create()
		ret?.name = name
		return ret
	}
}

extension CoreDataManager {
	
	@discardableResult
	static func create<T>() -> T? where T : NSManagedObject {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let entityName = "\(T.self)"
		let retVal = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
		
		do {
			try context.save()
			return retVal
		}
		catch let createError {
			print("Failed to create: \(createError)")
		}
		return nil
	}
	
	static func fetch<T>() -> [T]? where T : NSManagedObject {
		let context = shared.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
		
		do {
			let electors = try context.fetch(fetchRequest)
			return electors
		} catch let fetchError {
			print("Failed to fetch: \(fetchError)")
		}
		return nil
	}
	
	static func save() {
		let context = shared.persistentContainer.viewContext
		
		do {
			try context.save()
		}
		catch let saveError {
			print("Failed to save: \(saveError)")
		}
	}
	
	static func delete<T>(item: T) where T : NSManagedObject {
		let context = shared.persistentContainer.viewContext

		context.delete(item)
		do {
			try context.save()
		}
		catch let deleteError {
			print("Failed to delete: \(deleteError)")
		}
	}
	
	static func delete<T>(items: [T]) where T : NSManagedObject {
		let context = shared.persistentContainer.viewContext
		
		items.forEach { (item) in
			context.delete(item)
		}
		do {
			try context.save()
		}
		catch let deleteError {
			print("Failed to multi-delete: \(deleteError)")
		}
	}
}

extension CoreDataManager {
	
}
