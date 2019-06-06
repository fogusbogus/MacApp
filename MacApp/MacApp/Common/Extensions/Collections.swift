//
//  Collections.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class ColList {
	
	private var col : Dictionary<String, Array<String>> = Dictionary<String, Array<String>>()
	public var Columns : Dictionary<String, Array<String>> {
		get {
			return col
		}
	}
	
	public func toString(encoding: String.Encoding = .utf8) -> String {
		
		let maxRows = maxCount()
		
		var colWidths : [Int] = []
		for key in col.keys {
			var width = col[key]?.longestWidth(encoding: encoding)
			let keyWidth = key.length(encoding: encoding)
			if keyWidth > width! {
				width = keyWidth
			}
			colWidths.append(width!)
		}
		
		var sb = ""
		
		var rowWidth = "\(maxRows)".length(encoding: encoding)
		if rowWidth < 3 {
			rowWidth = 3
		}
		
		sb += "# || "
		let keys = Array(col.keys)
		let endPiece = " | "
		for i in 0..<keys.count {
			sb += keys[i].padRight(colWidths[i])
			if i < keys.count - 1 {
				sb.append(endPiece)
			}
		}
		
		let lineLength = sb.length(encoding: encoding)
		sb.append("\n")
		sb.append(String(repeating: "-", count: lineLength))
		sb.append("\n")
		
		for row in 0..<maxRows {
			sb.append("\(row + 1)".padRight(rowWidth))
			sb.append(" || ")
			for column in 0..<keys.count {
				let values = col[keys[column]]
				if (values?.count)! > row {
					sb.append(values![row].padRight(colWidths[column]))
				} else {
					sb.append(" ".repeating(colWidths[column]))
				}
			}
			sb.append("\n")
		}
		return sb
	}
	
	private func maxCount() -> Int {
		var max = 0
		for lst in col.values {
			if lst.count > max {
				max = lst.count
			}
		}
		return max
	}
	
}


extension Array where Element == String {
	/// In the array this returns the length of the longest item
	///
	/// - Parameter encoding: How is the string encoded
	/// - Returns: Length of the longest string
	func longestWidth(encoding: String.Encoding = .utf8) -> Int {
		var width = 0
		for item in self {
			
			let itemLength = item.length(encoding: encoding)
			if itemLength > width {
				width = itemLength
			}
		}
		return width
	}
	
	/// Filter a string array for a certain length
	///
	/// - Parameters:
	///   - length: How long should the items returned be?
	///   - encoding: How is the string encoded
	/// - Returns: All items that match the length specified
	func itemsWithLength(length: Int, encoding: String.Encoding = .utf8) -> Array? {
		return self.filter{$0.length(encoding: encoding) == length}
	}
	
	/// In the array this returns the length of the shortest item
	///
	/// - Parameter encoding: How is the string encoded
	/// - Returns: Length of the shortest string
	func shortestWidth(encoding: String.Encoding = .utf8) -> Int {
		if count == 0 {
			return 0
		}
		var width = Int.max
		for item in self {
			let itemLength = item.length(encoding: encoding)
			if itemLength < width {
				width = itemLength
			}
		}
		return width
	}
}
