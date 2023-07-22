//
//  Street.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : NewStreetDelegate {
	func canEditStreet(street: Street?) -> Bool {
		return street != nil
	}
	
	func cancelEditStreet(street: Street?) {
		guard let street = street else { return }
		closeWindow(window: WindowType(type: .editStreet, object: street))
	}
	
	func saveEditStreet(street: Street?) {
		try? street?.managedObjectContext?.save()
	}
	
	func cancelNewStreet(ward: Ward?) {
		guard let ward = ward else { return }
		closeWindow(window: WindowType(type: .newStreet, object: ward))
	}
	
	func saveNewStreet(ward: Ward?) {
		try? ward?.managedObjectContext?.save()
	}
	
}
