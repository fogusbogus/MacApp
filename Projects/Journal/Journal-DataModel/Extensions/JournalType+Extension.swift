//
//  JournalType+Extension.swift
//  Journal-DataModel
//
//  Created by Matt Hogg on 13/05/2022.
//

import Foundation
import CoreData

public extension JournalType {
	
	static func assertDefaults(context: NSManagedObjectContext) {
		assertMany(["Journal", "Private"], context: context)
	}

	@discardableResult
	static func assertMany(_ types: [String], callback: ((inout JournalType) -> Void)? = nil, context: NSManagedObjectContext) -> [JournalType] {
		var types = types
		let fetcher : NSFetchRequest<JournalType> = Self.fetchRequest()
		fetcher.sortDescriptors = [NSSortDescriptor(key: "version", ascending: false)]
		do {
			let results = try context.fetch(fetcher)
			results.forEach { st in
				var type = st
				if let cb = callback {
					cb(&type)
					do {
						try context.save()
					}
					catch {
						
					}
				}
				types.removeAll { s in
					return (st.name ?? "").implies(s)
				}
			}
		}
		catch {
			
		}
		
		//Add the default statuses
		types.forEach { type in
			var callbackType = JournalType(context: context)
			callbackType.name = type
			if let cb = callback {
				cb(&callbackType)
			}
			do {
				try context.save()
			}
			catch let ex {
				print(ex.localizedDescription)
			}
		}
		var ret : [Self] = []
		do {
			ret = try context.fetch(fetcher) as! [Self]
		}
		catch {
			
		}
		return ret.reduceToLatestVersion()
	}
}
