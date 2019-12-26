//
//  Strings.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension String {
	
	/////////////////////////////////////////////
	// Operator overloads
	/////////////////////////////////////////////
	
	/// (" " * 30) equates to 30 spaces
	///
	/// - Parameters:
	///   - left: What to repeat
	///   - noTimes: How many times to repeat it
	/// - Returns: String repeated n times
	static func *(left: String, noTimes: Int) -> String {
		return String(repeating: left, count: noTimes)
	}
	
	/// Keep the right hand item if it occurs in the left hand item
	///
	/// - Parameters:
	///   - left: Keep stuff from this
	///   - right: That appears in this§
	/// - Returns: Common text
	static func &(left: String, right: String) -> String {
		var ret = ""
		for i in 0...left.length() {
			let c = left.substring(from: i, to: i)
			if right.contains(c) {
				ret = ret + c
			}
		}
		return ret
	}
	
	static func |(left: String, right: String) -> String {
		var ret = left
		for i in 0...right.length() {
			let c = right.substring(from: i, to: i)
			if !ret.contains(c) {
				ret = ret + c
			}
		}
		return ret
	}
	
	static func -(left: String, right: String) -> String {
		var ret = left
		for i in 0...right.length() {
			let c = right.substring(from: i, to: i)
			if ret.contains(c) {
				ret = ret.replacingOccurrences(of: c, with: "")
			}
		}
		return ret
	}
	
	static func ^(left: String, right: String) -> String {
		var ret = left
		for i in 0...right.length() {
			let c = right.substring(from: i, to: i)
			if ret.contains(c) {
				ret = ret.replacingOccurrences(of: c, with: "")
			}
			else {
				ret = ret + c
			}
		}
		return ret
	}
	
	static func *=(text: inout String, count: Int) -> String {
		text = text * count
		return text
	}
	
	static func |=(left: inout String, chars: String) -> String {
		left = left | chars
		return left
	}
	
	static func -=(left: inout String, chars: String) -> String {
		left = left - chars
		return left
	}
	
	static func ^=(left: inout String, chars: String) -> String {
		left = left ^ chars
		return left
	}
	
	//Put in alphabetical order as there going to be lots of functions
	
	/////////////////////////////////////////////
	// A
	/////////////////////////////////////////////
	
	/// Returns the text after the given sequence
	///
	/// - Parameter sequence: Return the text after this
	/// - Parameter returnAllWhenMissing: If the sequence isn't found, return everything
	/// - Returns: The text after the given sequence
	func after(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		let start = index((range(of: sequence)?.upperBound)!, offsetBy: 0)
		let end = self.endIndex
		return String(self[start ..< end])
	}
	
	func appendDelimited(_ delimiter: String, appendThese: String...) -> String {
		var ret = "" + self
		for item in appendThese {
			if item.length() > 0 {
				if ret.length() > 0 {
					ret += delimiter
				}
				ret += item
			}
		}
		return ret
	}
	
	/////////////////////////////////////////////
	// B
	/////////////////////////////////////////////
	
	/// Returns the text before the given sequence
	///
	/// - Parameters:
	///   - sequence: Return the text before this
	///   - returnAllWhenMissing: If the sequence isn't found, return everything
	/// - Returns: The text before the given sequence
	func before(_ sequence: String, returnAllWhenMissing: Bool = false) -> String {
		if !self.contains(sequence) {
			if returnAllWhenMissing {
				return self
			}
			return ""
		}
		
		let end = index((range(of: sequence)?.upperBound)!, offsetBy: -1)
		let start = self.startIndex
		return String(self[start ..< end])
	}
	
	/////////////////////////////////////////////
	// C
	/////////////////////////////////////////////
	
	func countOccurrenceOf(_ ofThis: String, _ encoding: String.Encoding = .utf8) -> Int {
		let len = ofThis.length(encoding: encoding)
		
		guard len > 0 else {
			return 0
		}
		
		return (self.length(encoding: encoding) - self.replacingOccurrences(of: ofThis, with: "").length(encoding: encoding)) / len
	}
	
	/////////////////////////////////////////////
	// D
	/////////////////////////////////////////////
	
	func delimit(_ items: String...) -> String {
		let delimiter = "" + self
		var ret = ""
		for item in items {
			if item.length() > 0 {
				if ret.length() > 0 {
					ret += delimiter
				}
				ret += item
			}
		}
		return ret
	}

	func delimit(_ items: [String]) -> String {
		let delimiter = "" + self
		var ret = ""
		for item in items {
			if item.length() > 0 {
				if ret.length() > 0 {
					ret += delimiter
				}
				ret += item
			}
		}
		return ret
	}

	
	/////////////////////////////////////////////
	// F
	/////////////////////////////////////////////
	
	/// Similar to C# String.Format. This is highly simplified and only deals with {0} .. {n}
	///
	/// - Parameter params: Items used to replace numbered tags
	/// - Returns: Formatted text
	func fmt(_ params : Any...) -> String {
		var ret = self
		
		var index = 0
		for parm in params {
			ret = ret.replacingOccurrences(of: "{\(index)}", with: "\(parm)")
			index += 1
		}
		return ret
	}
	
	/// Converts a base-64 string to the required encoding text
	///
	/// - Parameter encoding: How to decode the base-64 string. Default uft8.
	/// - Returns: Decoded string
	func fromBase64(encoding: String.Encoding = .utf8) -> String? {
		guard let data = Data(base64Encoded: self) else {
			return nil
		}
		
		return String(data: data, encoding: encoding)
	}
	
	/////////////////////////////////////////////
	// G
	/////////////////////////////////////////////
	
	/// Ever wanted to check the pattern of a string? This supports upper/lower alphas, numbers and others. [Aa9?]
	func getPattern() -> String {
		let chars = Array(self)
		var ret = ""
		chars.forEach { (c) in
			if c.isLowercase {
				ret += "a"
			}
			else {
				if c.isUppercase {
					ret += "A"
				}
				else {
					if c.isNumber {
						ret += "9"
					}
					else {
						ret += "?"
					}
				}
			}
		}
		return ret
	}

	
	/////////////////////////////////////////////
	// I
	/////////////////////////////////////////////
	
	/// Returns the index of some sequence after a given start index
	///
	/// - Parameters:
	///   - text: Find this text
	///   - fromIndex: After this index
	/// - Returns: Index of the found text (-1 if not found)
	func indexOf(_ text: String, fromIndex: Int = 0) -> Int {
		let aft = self.substring(from: fromIndex)
		if !aft.contains(text) {
			return -1
		}
		
		let b4 = aft.before(text).length()
		return fromIndex + b4
	}
	
	func indexOfAny(_ text: String...) -> Int? {
		var idx = Int.max
		for item in text {
			let itemIdx = self.indexOf(item)
			if itemIdx < idx {
				idx = itemIdx
			}
		}
		if idx == Int.max {
			return nil
		}
		return idx
	}
	
	/// Returns comparison of the string to one of the parameters
	///
	/// - Parameter oneOfThese: Find one of these
	/// - Returns: The index of the found text
	func isOneOf(_ oneOfThese: String...) -> Bool {
		for item in oneOfThese {
			if item.compare(self) == ComparisonResult.orderedSame {
				return true
			}
		}
		return false
	}
	
	/// Caseless comparison
	///
	/// - Parameter doesItLookLikeThis: Compare it to this
	/// - Returns: Does it match?
	func implies(_ doesItLookLikeThis: String...) -> Bool {
		for item in doesItLookLikeThis {
			if self.caseInsensitiveCompare(item) == .orderedSame {
				return true
			}
		}
		return false
	}
	
	func impliesContains(_ doesItContainOneOfThese: String...) -> Bool {
		for item in doesItContainOneOfThese {
			if self.localizedCaseInsensitiveContains(item) {
				return true
			}
		}
		return false
	}
	
	func isEmptyOrWhitespace() -> Bool {
		return self.trim().length() == 0
	}
	
	/////////////////////////////////////////////
	// J
	/////////////////////////////////////////////
	
	//Joins parameters with a common delimiter
	func join(_ items: Any...) -> String {
		var ret = ""
		for i in 0..<items.count {
			if i > 0 {
				ret += self
			}
			ret += "\(items[i])"
		}
		return ret
	}
	
	//Joins parameters with a common delimiter and a final delimiter
	func join(finalSeparator: String, _ items: Any...) -> String {
		var ret = ""
		for i in 0..<items.count {
			if i > 0 {
				if i != items.count - 1 {
					ret += self
				}
				else {
					ret += finalSeparator
				}
			}
			ret += "\(items[i])"
		}
		return ret
	}
	
	func joinNonBlank(_ items: Any...) -> String {
		var ret = ""
		for i in 0..<items.count {
			let v = "\(items[i])".trim()
			if v.length() > 0 {
				if i > 0 {
					ret += self
				}
				ret += v
			}
		}
		return ret
	}
	
	//Joins parameters with a common delimiter and a final delimiter
	func joinNonBlank(finalSeparator: String, _ items: Any...) -> String {
		var ret = ""
		for i in 0..<items.count {
			let v = "\(items[i])".trim()
			if v.length() > 0 {
				if i > 0 {
					if i != items.count - 1 {
						ret += self
					}
					else {
						ret += finalSeparator
					}
				}
				ret += v
			}
		}
		return ret
	}
	
	
	/////////////////////////////////////////////
	// K
	/////////////////////////////////////////////
	
	//Filters a string for characters in another
	func keep(_ keepTheseChars: String, encoding: String.Encoding = .utf8) -> String {
		var ret = ""
		for i in 0...self.length(encoding: encoding) {
			let c = self.substring(from: i, to: i)
			if keepTheseChars.contains(c) {
				ret = ret + c
			}
		}
		return ret
	}
	
	/////////////////////////////////////////////
	// L
	/////////////////////////////////////////////
	
	//Returns the start of the string
	func left(_ maxLen: Int) -> String {
		return self.substring(from: 0, to: maxLen - 1)
	}
	
	//Returns the (default) utf8 length of the string
	func length(encoding: String.Encoding = .utf8) -> Int {
		return lengthOfBytes(using: encoding)
	}
	
	/////////////////////////////////////////////
	// N
	/////////////////////////////////////////////
	func nonBlank(_ subsequent : String...) -> String {
		if !self.trim().isEmpty {
			return self.trim()
		}
		
		for item in subsequent {
			if !item.trim().isEmpty {
				return item.trim()
			}
		}
		return self
	}
	
	/////////////////////////////////////////////
	// P
	/////////////////////////////////////////////
	
	//Pads the right of the string with spaces to make the string a strict length
	func padRight(_ width : Int, encoding: String.Encoding = .utf8) -> String {
		if self.lengthOfBytes(using: encoding) < width {
			return String(self + String(repeating: " ", count: width - self.lengthOfBytes(using: encoding)))
		}
		return self
	}
	
	
	//Returns the index of the string in a list of parameters
	func parameterIndexOf(_ parms: String...) -> Int {
		var ret = -1
		var index = 0
		var pos = Int.max
		for parm in parms {
			let count = self.before(parm).length()
			if count > 0 && count < pos {
				pos = count
				ret = index
			}
			index += 1
		}
		return ret
	}
	
	func pick(_ index: Int, _ items: String...) -> String {
		if index < 0 || index >= items.count {
			return self
		}
		return items[index]
	}
	
	func prefix(_ prefixWith: String, onlyWhenBlank: Bool = false) -> String {
		if (onlyWhenBlank && self.trim().length() > 0) || !onlyWhenBlank {
			return prefixWith + self
		}
		return self
	}
	
	/////////////////////////////////////////////
	// R
	/////////////////////////////////////////////
	
	//Removes multiple spaces and if required removes outer whitespaces
	func removeMultipleSpaces(_ trim: Bool = false) -> String {
		var ret = self.trimmingCharacters(in: .whitespaces).removeMultiple(" ")
		if trim {
			ret = ret.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		return ret
	}
	
	//Removes multiple instances inside a string
	func removeMultiples(_ of: String...) -> String {
		var ret = self
		for item in of {
			ret = ret.removeMultiple(item)
		}
		return ret
	}
	
	//Removes a multiple instance inside a string
	private func removeMultiple(_ of: String) -> String {
		let mult = of + of
		var text = self
		while text.contains(mult) {
			text = text.replacingOccurrences(of: mult, with: of)
		}
		return text
	}
	
	//Repeats a string n times
	func repeating(_ noTimes: Int) -> String {
		return self * noTimes
		//return String(repeating: self, count: noTimes)
	}
	
	//Returns the end of the string
	func right(_ maxLen: Int) -> String {
		let to = self.length()
		let from = (to - maxLen).max(0)
		return self.substring(from: from, to: to)
	}
	
	
	/////////////////////////////////////////////
	// S
	/////////////////////////////////////////////
	
	func sqlSafe() -> String {
		return self.replacingOccurrences(of: "'", with: "''")
	}
		
	//Returns the substring using from and to
	func substring(from: Int, to: Int) -> String {
		guard from < self.length() else { return "" }
		guard to >= 0 && from >= 0 && from <= to else {
			return ""
		}
		
		let start = index(startIndex, offsetBy: from)
		let end = index(startIndex, offsetBy: to.min(self.length() - 1))
		return String(self[start ... end])
	}
	
	//Returns the substring using from and length
	func substring(from: Int, length: Int) -> String {
		let to = from - 1 + length
		return self.substring(from: from, to: to)
	}
	
	//Returns the substring using from
	func substring(from: Int) -> String {
		let start = index(startIndex, offsetBy: from)
		let end = self.endIndex
		return String(self[start ..< end])    }
	
	//Returns the substring
	func substring(range: NSRange) -> String {
		return substring(from: range.lowerBound, to: range.upperBound)
	}
	
	func splitToArray(_ splitter: String) -> [String] {
		var ret : [String] = []
		var text = self
		var cand = text.before(splitter)
		while cand != "" {
			text = text.after(splitter)
			ret.append(cand)
			cand = text.before(splitter)
		}
		if text.length() > 0 {
			ret.append(text)
		}
		return ret
	}
	
	/////////////////////////////////////////////
	// T
	/////////////////////////////////////////////
	
	//Converts a utf8 string into base64
	func toBase64(encoding: String.Encoding = .utf8) -> String {
		return self.data(using: encoding, allowLossyConversion: false)!.base64EncodedString()
	}
	
	func trim(encoding: String.Encoding = .utf8) -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/////////////////////////////////////////////
	// U
	/////////////////////////////////////////////
	
	//Returns a utf8 length - deprecated
	func utf8Length() -> Int {
		return length(encoding: .utf8)
	}
	
}

public extension Data {
	var hexString: String {
		return map { String(format: "%02hhx", $0) }.joined()
	}
}

public extension String {
	func hexData() -> Data? {
		var data = Data(capacity: length() / 2)
		
		let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
		regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
			let byteString = (self as NSString).substring(with: match!.range)
			let num = UInt8(byteString, radix: 16)!
			data.append(num)
		}
		
		guard data.count > 0 else { return nil }
		
		return data
	}
}

public extension Array where Element == String {
	func containsLike(_ likeThis: String) -> Bool {
		return self.first(where: { (s) -> Bool in
			return s.implies(likeThis)
		}) != nil
	}
}
