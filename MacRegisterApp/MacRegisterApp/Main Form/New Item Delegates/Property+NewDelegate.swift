//
//  Property.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : NewPropertyDelegate {
	func cancelEditProperty(property: Abode?) {
		guard let property = property else { return }
		closeWindow(window: WindowType(type: .editProperty, object: property))
	}
	
	func saveEditProperty(property: Abode?) {
		try? property?.managedObjectContext?.save()
	}
	
	func cancelNewProperty(subStreet: SubStreet?) {
		guard let subStreet = subStreet else { return }
		closeWindow(window: WindowType(type: .newProperty, object: subStreet))
	}
	
	func saveNewProperty(subStreet: SubStreet?) {
		try? subStreet?.managedObjectContext?.save()
	}
	
	
}
