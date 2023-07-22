//
//  Elector+NewDelegate.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 11/06/2023.
//

import Foundation

extension MacRegisterAppApp : NewElectorDelegate {
	func cancelEditElector(elector: Elector?) {
		guard let elector = elector else { return }
		closeWindow(window: WindowType(type: .editElector, object: elector))
	}
	
	func saveEditElector(elector: Elector?) {
		try? elector?.managedObjectContext?.save()
	}
	
	func cancelNewElector(property: Abode?) {
		guard let property = property else { return }
		closeWindow(window: WindowType(type: .newElector, object: property))
	}
	
	func saveNewElector(property: Abode?) {
		try? property?.managedObjectContext?.save()
	}
	
	
}
