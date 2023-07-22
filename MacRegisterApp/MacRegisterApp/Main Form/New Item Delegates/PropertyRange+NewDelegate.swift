//
//  PropertyRange.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : NewPropertyRangeDelegate {
	/// Cancel a property range addition
	/// - Parameters:
	///   - substreet: We can add via substreet
	///   - street: We can add via street
	func cancelNew(substreet: SubStreet?, street: Street?) {
		if let substreet = substreet {
			closeWindow(window: WindowType(type: .newPropertyRange, object: substreet))
		}
		else {
			if let street = street {
				closeWindow(window: WindowType(type: .newPropertyRange, object: street))
			}
		}
	}
	
	/// Add a property range
	/// - Parameters:
	///   - subStreet: We can add to the substreet
	///   - street: We can add to the street (adds a new substreet)
	///   - items: A string array of items to add
	func okNew(subStreet: SubStreet?, street: Street?, items: [String], future: Bool = false) {
		guard let street = street else { return }
		let closeByStreet = subStreet == nil
		var ss = subStreet
		if subStreet == nil {
			var ssName = "\(street.subStreets?.count ?? 0)"
			while street.getSubStreets().contains(where: {$0.name! == ssName}) {
				ssName += ".new"
			}
			okNew(street: street, name: ssName, sortName: ssName)
			ss = street.getSubStreets().first(where: {$0.name! == ssName})
		}
		if let substreet = ss {
			let maxNo = items.compactMap {Int($0)}.max() ?? 0
			let maxLen = "\(maxNo)".length()
			let context = substreet.managedObjectContext ?? persistenceController.container.viewContext
			items.forEach { propName in
				let pr = Abode(context: context)
				pr.name = propName
				var sort = propName
				if let _ = Int(sort) {
					sort = String(repeating: "0", count: maxLen) + sort
					sort = sort.right(maxLen)
				}
				pr.sortName = sort
				pr.future = future
				substreet.addToAbodes(pr)
			}
			try? context.save()
			if closeByStreet {
				cancelNew(substreet: nil, street: street)
			}
			else {
				cancelNew(substreet: substreet, street: street)
			}
			let parentNode = tree.updateNode(data: substreet) { a,b in
				if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
					return a.objectID == b.objectID
				}
				return false
			}
			if parentNode != nil {
				parentNode?.expanded = true
				tree.selectedNode = parentNode?.findNode(data: substreet)
			}
			else {
				let stNode = tree.updateNode(data: substreet) { a,b in
					if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
						return a.objectID == b.objectID
					}
					return false
				}
				stNode?.expanded = true
				tree.selectedNode = stNode?.findNode(data: street)
			}
		}
	}
	

}
