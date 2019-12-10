//
//  ActionCodeCache.swift
//  RegisterDB
//
//  Created by Matt Hogg on 28/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

class ActionCodeCache {
	static let shared = ActionCodeCache()
	
	private init() {
	}
	
	private var _codes : [String:ActionCode] = [:]
	
	subscript(code: String) -> ActionCode? {
		get {
			if let key = _codes.keys.first(where: { (s) -> Bool in
				return s.implies(code)
			}) {
				return _codes[key]
			}
			return nil
		}
	}
	
	func assert(_ actionCode: ActionCode) {
		//Need to assert the code in here once you've create the properties
	}
	
	func allCodes() -> [String:ActionCode] {
		return _codes
	}
	
	func lookup(_ name: String) -> ActionCode? {
		let key = _codes.keys.first { (s) -> Bool in
			return s.implies(name)
		}
		if key != nil {
			return _codes[key!]
		}
		return nil
	}
	
	func lookupNoBlock(_ name: String) -> ActionCode? {
		var name = name
		if name.hasPrefix("*") {
			name = name.substring(from: 1)
		}
		let key = _codes.keys.first { (s) -> Bool in
			return s.implies(name)
		}
		if key != nil {
			return _codes[key!]
		}
		return nil

	}
}
