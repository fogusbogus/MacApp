//
//  Data+Navigational.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import Foundation

protocol DataNavigational {
	var symbol: String {get}
	var objectName: String {get}
	var sortingName: String {get}
}

enum DataNavigationalType {
	case pollingDistrict, ward, street, subStreet, abode, elector
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
