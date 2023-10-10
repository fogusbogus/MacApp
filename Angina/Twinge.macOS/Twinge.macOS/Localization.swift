//
//  Localisation.swift
//  Angina
//
//  Created by Matt Hogg on 21/04/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions

/// Allows a centralised method of getting a resource string
protocol LocalizationExtension {
	
}

/* Get a resource string in a less verbose manner */
extension LocalizationExtension {
	
	static func _resStr(file: String, cat: String, id: String) -> String {
		return parse(NSLocalizedString(id, tableName: file, bundle: Bundle.main, value: id, comment: cat), tableName: file, bundle: Bundle.main, cat: cat)
	}
	func _resStr(file: String, cat: String, id: String) -> String {
		return Self.parse(NSLocalizedString(id, tableName: file, bundle: Bundle.main, value: id, comment: cat), tableName: file, bundle: Bundle.main, cat: cat)
	}
	
	static func _resStr(file: String, bundle: Bundle, cat: String, id: String) -> String {
		return parse(NSLocalizedString(id, tableName: file, bundle: bundle, value: id, comment: cat), tableName: file, bundle: bundle, cat: cat)
	}
	func _resStr(file: String, bundle: Bundle, cat: String, id: String) -> String {
		return Self.parse(NSLocalizedString(id, tableName: file, bundle: bundle, value: id, comment: cat), tableName: file, bundle: bundle, cat: cat)
	}
	
	static func _resStr(cat: String, id: String) -> String {
		return parse(NSLocalizedString(id, comment: cat), cat: cat)
	}
	
	func _resStr(cat: String, id: String) -> String {
		return Self.parse(NSLocalizedString(id, comment: cat), cat: cat)
	}
	func _resStr(_ id: String) -> String {
		let name = "\(self)".before(":").splitToArray(".").last ?? ""
		return _resStr(cat: name, id: id)
	}
	
	private static func parse(_ result: String, tableName: String, bundle: Bundle, cat: String) -> String {
		var result = result
		while result.between("{", "}").lengthOfBytes(using: .utf8) > 0 {
			var lookup = result.between("{", "}")
			let replace = lookup
			var cat = cat
			if lookup.contains(":") {
				cat = lookup.before(":")
				lookup = lookup.after(":")
			}
			result = result.replacingOccurrences(of: "{\(replace)}", with: _resStr(file: tableName, bundle: bundle, cat: cat, id: lookup))
		}
		return result
	}
	
	private static func parse(_ result: String, cat: String) -> String {
		var result = result
		while result.between("{", "}").lengthOfBytes(using: .utf8) > 0 {
			var lookup = result.between("{", "}")
			let replace = lookup
			var cat = cat
			if lookup.contains(":") {
				cat = lookup.before(":")
				lookup = lookup.after(":")
			}
			result = result.replacingOccurrences(of: "{\(replace)}", with: _resStr(cat: cat, id: lookup))
		}
		return result
	}
}

extension String {
	func countOccurrence(_ ofThis: String) -> Int {
		if ofThis.lengthOfBytes(using: .utf8) == 0 {
			return 0
		}
		let current = self.lengthOfBytes(using: .utf8)
		let replaced = self.replacingOccurrences(of: ofThis, with: "").lengthOfBytes(using: .utf8)
		return (current - replaced) / ofThis.lengthOfBytes(using: .utf8)
	}
	
	func between(_ this: String, _ andThis: String) -> String {
		return self.after(this).before(andThis)
	}
}
