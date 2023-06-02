//
//  Data+Extensions.swift
//  MacRegisterSupport
//
//  Created by Matt Hogg on 20/05/2023.
//

import Foundation
import Cocoa

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
		let fetch = Abode.fetchRequest()
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
}

extension SubStreet {
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
}

extension Abode {
	func sorterText() -> String {
		return (subStreet?.sorterText() ?? "") + "." + (sortName ?? "") + (name ?? "")
	}

	func getElectors() -> [Elector] {
		return self.electors?.allObjects.compactMap {$0 as? Elector}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
}


extension Elector {
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
}
