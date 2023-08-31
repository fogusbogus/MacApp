//
//  Lane+Data+Extensions.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import Foundation

extension Lane {
		
	@discardableResult
	static func `getAll`(includeInvisible: Bool = false, onCollect: (([Lane]) -> Void)? = nil) -> [Lane] {
		let context = PersistenceController.shared.container.viewContext
		let fetch = Lane.fetchRequest()
		if !includeInvisible {
			fetch.predicate = NSPredicate(format: "visible = %d", true)
		}
		do {
			let ret = try context.fetch(fetch)
			onCollect?(ret)
			return ret
		}
		catch {
		}
		onCollect?([])
		return []
	}
	
	static func `get`(withName: String, includeInvisible: Bool = false) -> Lane? {
		return Log.return {
			let context = PersistenceController.shared.container.viewContext
			let fetch = Lane.fetchRequest()
			if includeInvisible {
				fetch.predicate = NSPredicate(format: "name LIKE %@", withName)
			}
			else {
				fetch.predicate = NSPredicate(format: "name LIKE %@ AND visible = %d", withName, true)
			}
			do {
				return try context.fetch(fetch).first
			}
			catch {
				Log.error(error)
			}
			return nil
		} pre: {
			Log.funcParams("Lane::get", items: ["withName":withName, "includeInvisible":includeInvisible])
		} post: { lane in
			Log.log("<< \(lane?.myObjectID ?? "nil")")
		}

	}
	
	typealias CreateOrUpdatePredicate = (lane: Lane, isNew: Bool)

	@discardableResult
	static func assert(withName: String, onCreateOrUpdate: ((CreateOrUpdatePredicate) -> Void)? = nil) -> Lane {
		if let ret = get(withName: withName, includeInvisible: true) {
			onCreateOrUpdate?((ret, false))
			return ret
		}
		let new = Lane(context: PersistenceController.shared.container.viewContext)
		new.name = withName
		onCreateOrUpdate?((new, true))
		return new
	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))")
	}
}
