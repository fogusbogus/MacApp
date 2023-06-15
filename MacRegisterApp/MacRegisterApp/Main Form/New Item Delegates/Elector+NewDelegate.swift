//
//  Elector+NewDelegate.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 11/06/2023.
//

import Foundation

extension MacRegisterAppApp : NewElectorDelegate {
	func cancel(elector: Elector?) {
		guard let elector = elector else { return }
		closeWindow(window: WindowType(type: .editElector, object: elector))
	}
	
	func save(elector: Elector?) {
		try? elector?.managedObjectContext?.save()
	}
	
	func cancel(property: Abode?) {
		guard let property = property else { return }
		closeWindow(window: WindowType(type: .newElector, object: property))
	}
	
	func save(property: Abode?) {
		try? property?.managedObjectContext?.save()
	}
	
	
}
