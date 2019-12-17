//
//  StringFunctions.swift
//  RegisterDB
//
//  Created by Matt Hogg on 17/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class StringFunctions {
	
	public static func generateGuid(_ length: Int = 16) -> String {
		return generateGuid("0123456789abcdef", length)
	}
	
	public static func generateGuid(_ usingChars: String, _ length: Int = 16) -> String {
		guard usingChars.length() > 0 else {
			return ""
		}
		guard length > 0 else {
			return ""
		}
		var ret = ""
		let chrs = Array(usingChars)
		let chrsLen = chrs.count
		for _ in 0..<length {
			ret += chrs[Int.random(in: 0..<chrsLen)].description
		}
		return ret
	}
	
}

public extension String {
	
	
	
	func prefixNonBlank(_ prefix: String) -> String {
		return self.isEmptyOrWhitespace() ? prefix : self;
	}
	
	func trimStart(_ prefixes: String...) -> String {
		var text = self
		while true {
			var canExit = true
			for prefix in prefixes {
				if text.hasPrefix(prefix) {
					canExit = false
					text = text.after(prefix)
				}
			}
			if canExit {
				return text
			}
		}
	}
	
	func trimEnd(_ prefixes: String...) -> String {
		var text = self
		while true {
			var canExit = true
			for prefix in prefixes {
				if text.hasSuffix(prefix) {
					canExit = false
					text = text.substring(from: 0, length: text.length() - prefix.length())
				}
			}
			if canExit {
				return text
			}
		}
	}
}
