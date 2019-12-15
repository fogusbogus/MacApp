//
//  Arrays.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension Array {
	
	func contains<T>(obj: T) -> Bool where T : Equatable {
		return self.filter({$0 as? T == obj}).count > 0
	}
	
	func toDelimitedString(delimiter: String) -> String {
		return self.toDelimitedString(delimiter: delimiter, finalDelimiter: delimiter)
	}
	
	func toDelimitedString(delimiter: String, finalDelimiter: String) -> String {
		var ret = ""
		let last = self.count - 1
		for i in 0..<self.count {
			if i > 0 {
				//Add a delimiter
				if i != last {
					ret += delimiter
				} else {
					ret += finalDelimiter
				}
			}
			ret += "\(self[i])"
		}
		return ret
	}
	
	func countOccurrencesOf<T>(obj: T) -> Int where T : Equatable {
		return self.filter({$0 as? T == obj}).count
	}
}

public extension Array where Element == String {
	func sqlStringList() -> String {
		let ret = self.map({ (s) -> String in
			return s.sqlSafe()
		}) .joined(separator: "','")
		return "'\(ret)'"
	}
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var jsonString: String? {
        if let dict = (self as AnyObject) as? Dictionary<String, AnyObject> {
            do {
				let data = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: UInt.zero))
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    return string
                }
            } catch {
                print(error)
            }
        }
        return nil
    }
}

public extension Array where Element : Hashable {
	func uniqueItems() -> [Element] {
		return Array(Set(self))
	}
}

public extension Array where Element : Equatable {
	/// Treats an array as a Set. Unique value assertion.
	///
	/// - Parameter element: The element to assert in the array
	mutating func assert(_ element: Element) {
		if !self.contains(obj: element) {
			self.append(element)
		}
	}
}

extension Data {
	func toBase64String(encoding: String.Encoding = .utf8) -> String? {
		return String(data: self.base64EncodedData(), encoding: encoding)
	}
	
	func fromBase64String(base64Data: String) -> Data? {
		return Data(base64Encoded: base64Data)
	}
}
