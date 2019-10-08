//
//  ConsoleOutput.swift
//  Common
//
//  Created by Matt Hogg on 05/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension String {
	
	func getKeys(keyAndValues: [Any]) -> [String] {
		return keyAndValues.enumerated().filter { (start, element) -> Bool in
			return start % 2 == 0
		}.map { (offset, element) -> String in
			return "\(element)"
		}
		
	}
	
	func getValues(keyAndValues: [Any]) -> [Any] {
		return keyAndValues.enumerated().filter { (start, element) -> Bool in
			return start % 2 == 1
		}
	}

	
	func tabsToSpaces(col: Int = 0, tabSpaceValue: Int = 8) -> String {
		var col = col
		var ret = ""
		let chars = Array(self)
		
		for c : Character in chars {
			if c == "\t" {
				ret.append(" ".repeating(tabSpaceValue - col % tabSpaceValue))
				col += (tabSpaceValue - col % tabSpaceValue)
			}
			else {
				if c == "\r" {
					col = 0
				}
				else {
					col += 1
				}
				ret.append(c)
			}
		}
		return ret
	}
	
	func getIndexes(findThese: [Character], filter: (Int) -> Bool) -> [Int] {
		var ret : [Int] = []
		for c in findThese {
			var i = self.indexOf(String(c))
			while i >= 0 {
				if filter(i) {
					ret.append(i)
				}
				i = self.indexOf(String(c), fromIndex: i + 1)
			}
		}
		ret.sort()
		return ret
	}
	
	func splitIntoLines(maxWidth : Int) -> [String] {
		
		//Lines can be separated by one of these
		let separators = " \n\t-;:?\\.,_"
		let separating = Array(separators)
		
		var lines : [String] = []
		var text = self
		while text.length() > 0 {
			text = text.tabsToSpaces()
			
			if text.length() < maxWidth {
				lines.append(text)
				break
			}
			
			let indexes = text.getIndexes(findThese: separating) { (index) -> Bool in
				return (0..<maxWidth).contains(index)
			}
			if indexes.count == 0 {
				//There are no separators
				//Create one
				lines.append(text.substring(from: 0, length: maxWidth))
				text = text.substring(from: maxWidth).trim()
			}
			else {
				let lastIndex = indexes.last!
				lines.append(text.substring(from: 0, length: lastIndex))
				text = text.substring(from: lastIndex).trim()
			}
		}
		return lines
	}
}
