//
//  Street.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : NewStreetDelegate {
	func cancelNew(ward: Ward?) {
		guard let ward = ward else { return }
		closeWindow(window: WindowType(type: .newStreet, object: ward))
	}
	
	func okNew(ward: Ward?, name: String, sortName: String) {
		//New STREET
		guard let ward = ward else { return }
		let context = ward.managedObjectContext ?? persistenceController.container.viewContext
		let st = Street(context: context)
		st.name = name
		st.sortName = sortName
		ward.addToStreets(st)
		try? context.save()
		cancelNew(ward: ward)
		let parentNode = tree.updateNode(data: ward) { a,b in
			if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
				return a.objectID == b.objectID
			}
			return false
		}
		parentNode?.expanded = true
		tree.selectedNode = parentNode?.findNode(data: st)
		
	}
	
}
