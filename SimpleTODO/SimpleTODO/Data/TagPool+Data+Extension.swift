//
//  TagPool+Data+Extension.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 28/07/2023.
//

import Foundation
import CoreData

extension TagPool {
	static func getAll() -> [TagPool] {
		let context = PersistenceController.shared.container.viewContext
		let fetch = TagPool.fetchRequest()
		do {
			let ret = try context.fetch(fetch)
			return ret.sorted(by: {$0.name! < $1.name!})
		}
		catch {}
		return []
	}
	
	static func getAllAsTagDeclaration() -> [TagDeclaration] {
		return getAll().asTagDeclarations()
	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))")
	}

}

extension Array where Element == TagPool {
	func asTagDeclarations() -> [TagDeclaration] {
		return self.map { TagDeclaration(id: String(describing: $0.objectID), text: $0.name ?? "") }
	}
}

extension Array {
	func whenEmpty(_ replaceWith: [Element]) -> [Element] {
		if self.count == 0 {
			return replaceWith
		}
		return self
	}
}
