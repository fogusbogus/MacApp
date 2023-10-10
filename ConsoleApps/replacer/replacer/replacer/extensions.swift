//
//  extensions.swift
//  replacer
//
//  Created by Matt Hogg on 13/03/2023.
//

import Foundation

extension String {
	func after(_ sequence: String, returnAllWhenMissing: Bool = false, caseSensitive: Bool = true) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		var start = index((range(of: sequence)?.upperBound)!, offsetBy: 0)
		if !caseSensitive {
			start = lowercased().index((range(of: sequence.lowercased())?.upperBound)!, offsetBy: 0)
		}
		let end = self.endIndex
		return String(self[start ..< end])
	}
	
	func before(_ sequence: String, returnAllWhenMissing: Bool = false, caseSensitive: Bool = true) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		var end = index((range(of: sequence)?.upperBound)!, offsetBy: -1)
		if !caseSensitive {
			end = lowercased().index((range(of: sequence.lowercased())?.upperBound)!, offsetBy: -1)
		}
		let start = self.startIndex
		return String(self[start ... end])
	}
	
	func splitBy(_ sequence: String, caseSensitive: Bool = true) -> [String] {
		var ret : [String] = []
		var text = self
		while text.lengthOfBytes(using: .utf8) > 0 {
			let item = text.before(sequence, returnAllWhenMissing: true, caseSensitive: caseSensitive)
			ret.append(item)
			text = text.after(sequence, returnAllWhenMissing: false, caseSensitive: caseSensitive)
		}
		return ret
	}
}
