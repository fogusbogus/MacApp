//
//  SubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI


extension MacRegisterAppApp : NewSubStreetDelegate {
	func cancelNew(street: Street?) {
		guard let street = street else { return }
		closeWindow(window: WindowType(type: .newSubStreet, object: street))
	}
	
	func okNew(street: Street?, name: String, sortName: String) {
		//New SUBSTREET
		guard let street = street else { return }
		let context = street.managedObjectContext ?? persistenceController.container.viewContext
		let ss = SubStreet(context: context)
		ss.name = name
		ss.sortName = sortName
		street.addToSubStreets(ss)
		try? context.save()
		cancelNew(street: street)
		let parentNode = tree.updateNode(data: street) { a,b in
			if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
				return a.objectID == b.objectID
			}
			return false
		}
		parentNode?.expanded = true
		tree.selectedNode = parentNode?.findNode(data: ss)
	}
	
}
