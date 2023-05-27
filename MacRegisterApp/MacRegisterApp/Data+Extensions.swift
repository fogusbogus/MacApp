//
//  Data+Extensions.swift
//  MacRegisterSupport
//
//  Created by Matt Hogg on 20/05/2023.
//

import Foundation

extension Abode {
	func street() -> Street? {
		return self.subStreet?.street
	}
	
	func ward() -> Ward? {
		return street()?.ward
	}
	
	func pollingDistrict() -> PollingDistrict? {
		return ward()?.pollingDistrict
	}
}

extension PollingDistrict {
	func getWards() -> [Ward] {
		return self.wards?.allObjects.compactMap {$0 as? Ward}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}

}

extension Ward {
	func getStreets() -> [Street] {
		return self.streets?.allObjects.compactMap {$0 as? Street}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}

}

extension Street {
	func getSubStreets() -> [SubStreet] {
		return self.subStreets?.allObjects.compactMap {$0 as? SubStreet}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
	
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
}

extension SubStreet {
	func sorterText() -> String {
		return (sortName ?? "") + (name ?? "")
	}
}

extension Abode {
	func sorterText() -> String {
		return (name ?? "")
	}

}
