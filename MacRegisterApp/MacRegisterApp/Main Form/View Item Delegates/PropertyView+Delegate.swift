//
//  PropertyView.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension MacRegisterAppApp : PropertyViewDelegate {
	func getSelectedAbode() -> Abode? {
		return currentAbode
	}
	
	
	func selectionChanged(abode: Abode?) {
		currentAbode = abode
	}
	

}
