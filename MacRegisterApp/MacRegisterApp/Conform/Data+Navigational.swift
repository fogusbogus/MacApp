//
//  Data+Navigational.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import Foundation
import SwiftUI

protocol DataNavigational : NSManagedObject {
	var symbol: String {get}
	var objectName: String {get}
	var sortingName: String {get}
	func inspect() -> String
}

enum DataNavigationalType : String {
	case pollingDistrict = "PD", ward = "WD", street = "ST", subStreet = "SS", abode = "PR", elector = "EL"
}

extension PollingDistrict : DataNavigational {
	var symbol: String {
		return "🇬🇧"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
	
}
extension Ward : DataNavigational {
	var symbol: String {
		return "🎗️"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
}
extension Street : DataNavigational {
	var symbol: String {
		return "🏘️"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
}
extension SubStreet : DataNavigational {
	var symbol: String {
		return "📍"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
}
extension Abode : DataNavigational {
	var symbol: String {
		return "🏠"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
}
extension Elector : DataNavigational {
	var symbol: String {
		return "🥸"
	}
	var objectName: String { name ?? "" }
	var sortingName: String { sortName ?? "" }
}
