//
//  DelimitedString.swift
//  Common
//
//  Created by Matt Hogg on 07/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class DelimitedString {
	
	public init() {}
	public init(_ array: [Any]) {
		appendArray(array)
	}
	
	private var _items : [String] = []
	
	public var Delimiter : String = ""
	
	public static func count(inThis: String, delimiter: String, ignoreCase: Bool = false) -> Int {
		if delimiter.length() == 0 || inThis.isEmpty {
			return 0
		}
		
		if ignoreCase {
			return (inThis.length() - inThis.replacingOccurrences(of: delimiter, with: "", options: .caseInsensitive, range: nil).length()) / delimiter.length()
		}
		return (inThis.length() - inThis.replacingOccurrences(of: delimiter, with: "", options: .literal, range: nil).length()) / delimiter.length()

	}
	
	public func remove(_ item: String) {
		_items.removeAll { (s) -> Bool in
			return s == item
		}
	}
	
	public func contains(_ value: String, ignoreCase: Bool = false) -> Bool {
		return _items.first { (s) -> Bool in
			if ignoreCase {
				return s.implies(value)
			}
			return s == value
		} != nil
	}
	
	public func appendUnique(_ values: Any...) {
		for value in values {
			let sValue = "\(value)"
			if (!contains(sValue, ignoreCase: true)) {
				_items.append(sValue)
			}
		}
	}
	
	public func appendArray(_ array: [Any], unique: Bool = false) {
		for item in array {
			if unique {
				appendUnique(item)
			}
			else {
				append(item)
			}
		}
	}
	
	public func append(_ values: Any...) {
		for value in values {
			let sValue = "\(value)"
			_items.append(sValue)
		}
	}
	
	

	public func toString(delimiter: String, finalDelimiter: String, startIndex: Int, length: Int) -> String {
		if _items.count == 0 {
			return ""
		}
		if _items.count == 1 {
			return _items[0]
		}
		if _items.count == 2 {
			return _items[0] + finalDelimiter + _items[1]
		}
		let finalItem = _items[_items.count - 1]
		var items = _items
		items.removeLast()
		return delimiter.delimit(items) + finalDelimiter + finalItem
	}
	
	public func toString(delimiter: String, finalDelimiter: String) -> String {
		return toString(delimiter: delimiter, finalDelimiter: finalDelimiter, startIndex: 0, length: _items.count)
	}
	public func toString(_ delimiter: String) -> String {
		return toString(delimiter: delimiter, finalDelimiter: delimiter)
	}
	public func toString() -> String {
		return toString(Delimiter)
	}
	
	public var Count : Int {
		get {
			return _items.count
		}
	}
	
	public func clear() {
		_items = []
	}
	
	public var items : [String] {
		get {
			return _items
		}
	}
}
