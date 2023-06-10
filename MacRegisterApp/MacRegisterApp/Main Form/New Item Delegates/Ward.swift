//
//  Ward.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : NewWardDelegate {
	func cancelNew(pollingDistrict: PollingDistrict?) {
		guard let pollingDistrict = pollingDistrict else { return }
		closeWindow("new-wd_\(pollingDistrict.id)")
	}
	
	func okNew(pollingDistrict: PollingDistrict?, name: String, sortName: String) {
		//New WARD
		guard let pollingDistrict = pollingDistrict else { return }
		let context = pollingDistrict.managedObjectContext ?? persistenceController.container.viewContext
		let wd = Ward(context: context)
		wd.name = name
		wd.sortName = sortName
		pollingDistrict.addToWards(wd)
		try? context.save()
		cancelNew(pollingDistrict: pollingDistrict)
		let parentNode = tree.updateNode(data: pollingDistrict) { a,b in
			if let a = a as? NSManagedObject, let b = b as? NSManagedObject {
				return a.objectID == b.objectID
			}
			return false
		}
		parentNode?.expanded = true
		tree.selectedNode = parentNode?.findNode(data: wd)
	}
	
}
