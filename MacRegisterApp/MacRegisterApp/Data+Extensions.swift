//
//  Data+Extensions.swift
//  MacRegisterSupport
//
//  Created by Matt Hogg on 20/05/2023.
//

import Foundation
import Cocoa

extension Street {
	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Street? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch : NSFetchRequest<Street> = Street.fetchRequest()
		fetch.predicate = NSPredicate(format: "self IN %@", [id])
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
	
	static func findById(id: NSManagedObjectID, context: NSManagedObjectContext? = nil) -> Street? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch : NSFetchRequest<Street> = Street.fetchRequest()
		fetch.predicate = NSPredicate(format: "self IN %@", [id])
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append(["name":name, "sortName":sortName, "postCode":postCode, "meta":meta, "subStreetCount":subStreetCount])
		
		d.append(["id":id, "hasChanged":hasChanges, "hasPersistentChangedValues":hasPersistentChangedValues, "isDeleted":isDeleted, "isFault":isFault, "isUpdated":isUpdated, "isInserted":isInserted] as [String : Any])
		return d.jsonString ?? ""
	}
}

extension Dictionary where Key == String, Value == String {
	mutating func append(_ pairs: Any?...) {
		for i in stride(from: 0, through: pairs.count - 1, by: 2) {
			
			if let key = pairs[i] as? String, let value = pairs[i+1] {
				self[key] = String(describing: value)
			}
		}
	}
	
	mutating func append(_ pairs: [String:Any?]) {
		pairs.forEach { kv in
			if let v = kv.value {
				self[kv.key] = String(describing: v)
			}
		}
	}
	
//	mutating func append(_ pairs: [String:Any]) {
//		pairs.forEach { kv in
//			self[kv.key] = String(describing: kv.value)
//		}
//	}
}

extension Abode {
	func street() -> Street? {
		return self.subStreet?.street
	}
	
	func ward() -> Ward? {
		return street()?.ward
	}
	
	func pollingDistrict() -> PollingDistrict? {
		return ward()?.pollingDistrict
	}
	
	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Abode? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch : NSFetchRequest<Abode> = Abode.fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
	
	
	static func findById(id: String, context: NSManagedObjectContext? = nil) -> Abode? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch : NSFetchRequest<Abode> = Abode.fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append("name", name, "sortName", sortName, "type", type, "meta", meta, "electorCount", electorCount)
		d.append("id", self.id, "hasChanged", self.hasChanges, "hasPersistentChangedValues", self.hasPersistentChangedValues, "isDeleted", self.isDeleted, "isFault", self.isFault, "isUpdated", self.isUpdated, "isInserted",self.isInserted)
		return d.jsonString ?? ""
	}

}

extension PollingDistrict {
	func getWards() -> [Ward] {
		return self.wards?.allObjects.compactMap {$0 as? Ward}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}

	func getStreets() -> [Street] {
		return getWards().flatMap {$0.getStreets()}
	}
	
	func getSubstreets() -> [SubStreet] {
		return getStreets().flatMap {$0.getSubStreets()}
	}
	
	func getAbodes() -> [Abode] {
		return getSubstreets().flatMap {$0.getAbodes()}
	}
	
	func getElectors() -> [Elector] {
		return getAbodes().flatMap {$0.getElectors()}
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append("name", name, "sortName", sortName, "meta", meta, "wardCount", wardCount)
		d.append("id", self.id, "hasChanged", self.hasChanges, "hasPersistentChangedValues", self.hasPersistentChangedValues, "isDeleted", self.isDeleted, "isFault", self.isFault, "isUpdated", self.isUpdated, "isInserted",self.isInserted)
		return d.jsonString ?? ""
	}

	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> PollingDistrict? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
	static func findById(id: String, context: NSManagedObjectContext? = nil) -> PollingDistrict? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()

		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
}

extension Ward {
	func getStreets() -> [Street] {
		return self.streets?.allObjects.compactMap {$0 as? Street}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
	func getSubstreets() -> [SubStreet] {
		return getStreets().flatMap {$0.getSubStreets()}
	}
	
	func getAbodes() -> [Abode] {
		return getSubstreets().flatMap {$0.getAbodes()}
	}
	
	func getElectors() -> [Elector] {
		return getAbodes().flatMap {$0.getElectors()}
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append("name", name, "sortName", sortName, "meta", meta, "streetCount", streetCount)
		d.append("id", self.id, "hasChanged", self.hasChanges, "hasPersistentChangedValues", self.hasPersistentChangedValues, "isDeleted", self.isDeleted, "isFault", self.isFault, "isUpdated", self.isUpdated, "isInserted",self.isInserted)
		return d.jsonString ?? ""
	}

	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Ward? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}

	static func findById(id: String, context: NSManagedObjectContext? = nil) -> Ward? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
}

extension Street {
	func getSubStreets() -> [SubStreet] {
		return self.subStreets?.allObjects.compactMap {$0 as? SubStreet}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
	
//	func getAbodes() -> [Abode] {
//		return getSubstreets().flatMap {$0.getAbodes()}
//	}
	
	func getElectors() -> [Elector] {
		return getAbodes().flatMap {$0.getElectors()}
	}
	
//	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Street? {
//		let context = context ?? PersistenceController.shared.container.viewContext
//		let fetch = fetchRequest()
//		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
//		do {
//			let res = try context.fetch(fetch)
//			return res.first
//		}
//		catch {
//
//		}
//		return nil
//	}
	
	static func findById(id: String, context: NSManagedObjectContext? = nil) -> Street? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
}

extension SubStreet {
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append("name", name, "sortName", sortName, "meta", meta, "propertyCount", propertyCount)
		d.append("id", self.id, "hasChanged", self.hasChanges, "hasPersistentChangedValues", self.hasPersistentChangedValues, "isDeleted", self.isDeleted, "isFault", self.isFault, "isUpdated", self.isUpdated, "isInserted",self.isInserted)
		return d.jsonString ?? ""
	}

	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> SubStreet? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}

	static func findById(id: String, context: NSManagedObjectContext? = nil) -> SubStreet? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
}

extension Abode {
	func sorterText() -> String {
		return (subStreet?.sorterText() ?? "") + "." + (sortName ?? "") + (name ?? "")
	}

	func getElectors() -> [Elector] {
		return self.electors?.allObjects.compactMap {$0 as? Elector}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	
//	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Abode? {
//		let context = context ?? PersistenceController.shared.container.viewContext
//		let fetch = fetchRequest()
//		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
//		do {
//			let res = try context.fetch(fetch)
//			return res.first
//		}
//		catch {
//
//		}
//		return nil
//	}

//	static func findById(id: String, context: NSManagedObjectContext? = nil) -> Abode? {
//		let context = context ?? PersistenceController.shared.container.viewContext
//		let fetch = fetchRequest()
//		fetch.predicate = NSPredicate(format: "recordName == %@", "\(text)")
//		do {
//			let res = try context.fetch(fetch)
//			return res.first
//		}
//		catch {
//			
//		}
//		return nil
//	}
}


extension Elector {
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
	
	func inspect() -> String {
		var d : [String:String] = [:]
		
		d.append("name", name, "sortName", sortName, "meta", meta, "email", self.email, "markers", self.markers, "salutation", self.salutation, "validation", self.validation)
		d.append("id", self.id, "hasChanged", self.hasChanges, "hasPersistentChangedValues", self.hasPersistentChangedValues, "isDeleted", self.isDeleted, "isFault", self.isFault, "isUpdated", self.isUpdated, "isInserted",self.isInserted)
		return d.jsonString ?? ""
	}

	static func findById(id: ObjectIdentifier, context: NSManagedObjectContext? = nil) -> Elector? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}

	static func findById(id: String, context: NSManagedObjectContext? = nil) -> Elector? {
		let context = context ?? PersistenceController.shared.container.viewContext
		let fetch = fetchRequest()
		fetch.predicate = NSPredicate(format: "recordName == %@", "\(id)")
		do {
			let res = try context.fetch(fetch)
			return res.first
		}
		catch {
			
		}
		return nil
	}
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
	var jsonString: String? {
		if let dict = (self as AnyObject) as? Dictionary<String, AnyObject> {
			do {
				let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(arrayLiteral: [.sortedKeys, .withoutEscapingSlashes]))
				if let string = String(data: data, encoding: String.Encoding.utf8) {
					return string
				}
			} catch {
				print(error)
			}
		}
		return nil
	}
}


extension String {
	func substitute(_ others: String?...) -> String {
		let candidates = others.compactMap {$0}.filter {!$0.isEmptyOrWhitespace()}
		if self.isEmptyOrWhitespace() {
			return candidates.first ?? ""
		}
		return self
	}
}

extension Optional where Wrapped == String {
	func substitute(_ others: String?...) -> String {
		let candidates = others.compactMap {$0}.filter {!$0.isEmptyOrWhitespace()}
		if (self ?? "").isEmptyOrWhitespace() {
			return candidates.first ?? ""
		}
		return self!
	}
}

extension Array where Element == DataNavigational {
	func named(_ namedLike: String, butNot: DataNavigational...) -> DataNavigational? {
		let butNot = butNot.compactMap {$0 as NSManagedObject}
		let items = self.compactMap {$0 as NSManagedObject}.filter {!butNot.contains($0)}.compactMap {$0 as? DataNavigational}
		return items.first(where: {$0.objectName.implies(namedLike)})
	}
}

extension DataNavigational {
	func equals(_ object: AnyObject) -> Bool {
		if let nsObj = object as? NSManagedObject {
			return nsObj.objectID == objectID
		}
		if let obj = object as? DataNavigational {
			return self.objectName == obj.objectName
		}
		return false
	}
}
