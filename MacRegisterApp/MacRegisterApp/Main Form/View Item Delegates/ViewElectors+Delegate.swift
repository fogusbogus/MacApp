//
//  ViewElectors+Delegate.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 11/06/2023.
//

import Foundation

extension MacRegisterAppApp : ViewElectorsDelegate {
	func getSelectedElector() -> Elector? {
		return selectedElector
	}
	
	func select(elector: Elector?) {
		selectedElector = elector
	}
	
	
}
