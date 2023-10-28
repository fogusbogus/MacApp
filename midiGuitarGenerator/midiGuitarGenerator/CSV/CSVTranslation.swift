//
//  CSVTranslation.swift
//  mdigtr
//
//  Created by Matt Hogg on 13/09/2023.
//

import Foundation

extension CSV {
	class CSVTranslation {
		struct Options {
			var trim = true
			var alignColumnCount = false
			var rowSplitChars = ["\n"]
			var columnSplitChars = [","]
			var columnEscapes = ["\""]
			var allowLeadingWhitespacesBeforeEscapes = true
		}
		
		private static func countColumnEscapes(data: String, escape: String, options: Options) -> Int {
			let indexes = data.ranges(of: escape)
			var count = 0
			let breaking = [escape] + options.columnSplitChars + options.rowSplitChars
			indexes.forEach { index in
				
				let followingChar = data.slice(data.index(index.upperBound, offsetBy: 1), data.index(index.upperBound, offsetBy: 2))
				let isOpeningEscape = count % 2 == 0
				if followingChar.count == 0 || breaking.contains(followingChar) || isOpeningEscape {
					count += 1
				}
			}
			return count
		}
		
		private static func isOutsideColumnEscapes(data: String, options: Options) -> Bool {
			guard data.count > 0 else { return true }
			let compareData = options.allowLeadingWhitespacesBeforeEscapes ? data.trimmingCharacters(in: .whitespacesAndNewlines) : data
			let firstChar = String(compareData.prefix(1))
			if options.columnEscapes.contains(firstChar) {
				return countColumnEscapes(data: data, escape: firstChar, options: options) % 2 == 0
			}
			return true
		}
		
		private static func trimToColumnEscapes(text: String, options: Options) -> String {
			var text = text
			if options.allowLeadingWhitespacesBeforeEscapes {
				if options.columnEscapes.first(where: {text.trimmingPrefix(while: {$0.isWhitespace}).hasPrefix($0)}) != nil {
					text = String(text.trimmingPrefix(while: {$0.isWhitespace}))
				}
			}
			if options.columnEscapes.first(where: {text.hasPrefix($0)}) != nil {
				let escape = String(text.prefix(1))
				while !text.hasSuffix(escape) {
					text.removeLast()
				}
			}
			return text
		}
		
		private static func getCSVFlatArray(csv: String, options: Options) -> [String] {
			let allChars = Array(csv)
			var data: [String] = []
			var currentData = ""
			allChars.forEach { chr in
				if (options.columnSplitChars.contains(String(chr)) || options.rowSplitChars.contains(String(chr))) && isOutsideColumnEscapes(data: currentData, options: options) {
					data.append(trimToColumnEscapes(text: currentData, options: options))
					currentData = ""
					if options.rowSplitChars.contains(String(chr)) {
						data.append(String(chr))
					}
				}
				else {
					currentData += String(chr)
				}
			}
			
			if allChars.count > 0 {
				data.append(trimToColumnEscapes(text: currentData, options: options))
			}
			return data
		}
		
		private static func removeColumnEscapes(text: String, options: Options) -> String {
			var text = text
			if options.columnEscapes.contains(where: { encapsulator in
				if options.allowLeadingWhitespacesBeforeEscapes {
					return text.trimmingPrefix(while: {$0.isWhitespace}).hasPrefix(encapsulator) && text.hasSuffix(encapsulator)
				}
				return text.hasPrefix(encapsulator) && text.hasSuffix(encapsulator)
			}) {
				let escape = String(options.allowLeadingWhitespacesBeforeEscapes ? text.trimmingPrefix(while: {$0.isWhitespace}).prefix(1) : text.prefix(1))
				text.removeFirst()
				text.removeLast()
				text = text.replacingOccurrences(of: escape + escape, with: escape)
				return text
			}
			
			if options.trim {
				return text.trimmingCharacters(in: .whitespaces)
			}
			return text
		}
		
		private static func ensureMinimumColumnCount(array: [[String]], count: Int) -> [[String]] {
			var ret: [[String]] = []
			array.forEach { row in
				var newRow = row
				while newRow.count < count {
					newRow.append("")
				}
				ret.append(newRow)
			}
			return ret
		}
		
		static func getArrayFromCSVContent(csv: String, options: Options? = nil) -> [[String]] {
			let options = options ?? Options()
			
			var ret: [[String]] = []
			var current: [String] = []
			var maxCols = 0
			let data = getCSVFlatArray(csv: csv.replacingOccurrences(of: "\r\n", with: "\n"), options: options)
			data.forEach { item in
				if options.rowSplitChars.contains(item) {
					if maxCols < current.count {
						maxCols = current.count
					}
					ret.append(current)
					current = []
				}
				else {
					current.append(removeColumnEscapes(text: item, options: options))
				}
			}
			
			//Residual data
			if current.count > 0 {
				if maxCols < current.count {
					maxCols = current.count
				}
				ret.append(current)
			}
			
			if !options.alignColumnCount {
				return ensureMinimumColumnCount(array: ret, count: 1)
			}
			return ensureMinimumColumnCount(array: ret, count: maxCols)
		}
	}
}

extension StringProtocol {
	func ranges(of targetString: Self, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
		
		let result: [Range<String.Index>] = self.indices.compactMap { startIndex in
			let targetStringEndIndex = index(startIndex, offsetBy: targetString.count, limitedBy: endIndex) ?? endIndex
			return range(of: targetString, options: options, range: startIndex..<targetStringEndIndex, locale: locale)
		}
		return result
	}
	
	func slice(_ startIndex: Index, _ endIndex: Index) -> String {
		guard startIndex >= self.startIndex else { return "" }
		if endIndex > self.endIndex {
			return String(self[startIndex..<self.endIndex])
		}
		return String(self[startIndex..<endIndex])
	}
}
