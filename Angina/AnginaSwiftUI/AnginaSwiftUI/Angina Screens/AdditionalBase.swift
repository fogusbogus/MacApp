//
//  AdditionalBase.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 13/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import Foundation

class AdditionalBase : ObservableObject {
	@Published var update : Bool = false
	
	var canUpdate: Bool { get { return false } }
	
	func reset() {
		
	}
	
	func getSaveData() -> [String:Any] {
		return [:]
	}
	
	final func collectSaveData(_ title: String, data: [String:Any]) -> [String:Any] {
		if data.count > 0 {
			return [title:data]
		}
		return [:]
	}
	
}

extension Dictionary where Key == String {
	static func +(left: Self, right: Self) -> Self {
		var ret = left
		right.forEach { (kv) in
			let (key, value) = kv
			ret[key] = value
		}
		return ret
	}
}
