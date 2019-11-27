//
//  CSVStringExtensions.swift
//  Common
//
//  Created by Matt Hogg on 16/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation


public extension String {
	func getPieces() -> [String] {
		let base : [String] = self.components(separatedBy: ",")
		//let base = self.split(separator: ",")
		var ret : [String] = []
		
		var quoteCount: Int = 0
		var lastValue = ""
		for item in base {
			let sItem = lastValue + String(item)
			quoteCount = sItem.count(text: "\"") % 2
			if quoteCount == 0 {
				ret.append(sItem)
				lastValue = ""
			}
			else {
				lastValue = sItem
			}
		}
		if lastValue.length() > 0 {
			ret.append(lastValue)
		}
		return ret
	}
	
	
	func count(text: String) -> Int {
		return self.length() -  self.replacingOccurrences(of: text, with: "").length()
	}
	// 4,"This, is some text",3
	// {4} {"This} { is some text"} {3}
}

public extension Array where Element == String {
	
	func get<T>(_ columns: [String], _ column: String, _ defaultValue: T) -> T {
		let colIndex = columns.map { (s) -> String in
			return s.lowercased()
		}.firstIndex(of: column.lowercased())
		if colIndex != nil {
			return get(colIndex!, defaultValue)
		}
		return defaultValue
	}
	
	func get<T>(_ pieceNo : Int, _ defaultValue: T) -> T {
		if pieceNo < 0 || pieceNo >= self.count {
			return defaultValue
		}
		let piece = String(self[pieceNo])
		if defaultValue is Int {
			return Int(piece) as? T ?? defaultValue
		}
		if defaultValue is Bool {
			return Bool(piece) as? T ?? defaultValue
		}
		if defaultValue is Double {
			return Double(piece) as? T ?? defaultValue
		}
		if defaultValue is Float {
			return Float(piece) as? T ?? defaultValue
		}
		if defaultValue is String {
			var ret = piece
			if ret.hasPrefix("\"") && ret.hasSuffix("\"") {
				ret = ret.substring(from: 1, length: ret.length() - 2)
			}
			return ret as? T ?? defaultValue
		}
		return piece as? T ?? defaultValue
	}
}
