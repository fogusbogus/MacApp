//
//  IDProvider.swift
//  Common
//
//  Created by Matt Hogg on 31/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class IDProvider {
	public static let shared = IDProvider()
	
	private init() {
	}
	
	private var _id: [String:Int] = [:]
	
	public func nextID(_ key: String, includeKeyInValue: Bool = true) -> String {
		let k = _id.keys.first { (itemKey) -> Bool in
			return itemKey.implies(key)
		} ?? key
		if !_id.keys.contains(k) {
			_id[k] = 0
		}
		_id[k] = _id[k]! + 1
		let ret = "0000000000\(_id[k]!)"
		if includeKeyInValue {
			return k + substring(text: ret, from: ret.length(encoding: .utf8) - 10)
		}
		return substring(text: ret, from: ret.length(encoding: .utf8) - 10)
	}
	
	private func substring(text: String, from: Int) -> String {
		let start = text.index(text.startIndex, offsetBy: from)
		let end = text.endIndex
		return String(text[start ..< end])
	}
}
