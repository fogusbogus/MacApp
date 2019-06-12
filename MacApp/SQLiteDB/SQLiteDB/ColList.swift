//
//  ColList.swift
//  SQLiteDB
//
//  Created by Matt Hogg on 09/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import Common
import DBLib

/*

TODO: Make the column splitters into their own ConsoleColumn instance in the array.

*/


class ColList {
	private var _cols : [ConsoleColumn] = []
	
	private var _data : [SQLRow] = []
	
	func fromSQLRowArray(_ rows: [SQLRow]) {
		_data = rows
		let rowColLength = "\(rows.count)".length()
		_cols = []
		let cc = ConsoleColumn(preferredSize: rowColLength, minimumSize: rowColLength, caption: "#")
		cc.Color = .white
		cc.Name = ""
		cc.MinimumSize = rowColLength
		
		_cols.append(cc)
		for col in rows.columns() {
			//Now we need a separator
			var c = ConsoleColumn(preferredSize: 3, minimumSize: 3, caption: " | ")
			c.Color = .yellow
			_cols.append(c)

			//Get the maximum length of the data in the column for all rows
			var maxSize = rows.max { (a, b) -> Bool in
				return a.text(col, "").length() <= b.text(col, "").length()
			}?.text(col, "").length() ?? 0
			if maxSize < col.length() {
				maxSize = col.length()
			}
			
			//Now the column definition
			c = ConsoleColumn(preferredSize: maxSize, minimumSize: col.length(), caption: col)
			c.Name = col
			c.Color = .white
			
			_cols.append(c)
			

		}
	}
	
	func outputToConsole(maxWidth: Int = 80) {
		_cols.fitToWidth(maxWidth: maxWidth)
		var line = "" //ANSIColors.white.rawValue
		for i in 0..<_cols.count {
			line += /*_cols[i].Color.rawValue +*/ _cols[i].Caption.padRight(_cols[i].OutputSize)
		}
		print(line)
		line = ""
		for i in 0..<_cols.count {
			line += _cols[i].Separator()
		}
		print(line)
		line = ANSIColors.white.rawValue
		var rowNo = 0
		for row in _data {

			rowNo += 1
			
			//Setup the col with some data
			_cols[0].Caption = "\(rowNo)"
			
			for col in _cols {
				if col.Name != "" {
					//This is mapped to a real column
					col.CurrentText = row.text(col.Name, "")
				}
			}
			
			while _cols.hasData() {
				line = ""
				for i in 0..<_cols.count {

					line += /*_cols[i].Color.rawValue +*/ _cols[i].output()
				}
				print(line)
				line = ANSIColors.white.rawValue
			}
		}
	}
}

class ConsoleColumn {
	var MinimumSize : Int = 3
	var PreferredSize : Int = 64
	var OutputSize : Int = 0
	private var _caption = ""
	
	var Caption : String {
		get {
			return _caption
		}
		set {
			_caption = newValue
			MinimumSize = _caption.length()
		}
	}
	
	func Separator(_ text: String = "-") -> String {
		return text.repeating(OutputSize).left(OutputSize)
	}
	
	var Name = ""
	
	var Color : ANSIColors = .white
	
	init(preferredSize: Int, minimumSize: Int = 3, caption: String = "") {
		self.PreferredSize = preferredSize
		self.OutputSize = preferredSize
		self.Caption = caption
	}
	
	var CurrentText = ""
	var StaticText = ""
	
	func centred() -> String {
		let mx = OutputSize / 2 - CurrentText.length() / 2
		if mx < 0 {
			return CurrentText.substring(from: 0, length: OutputSize)
		}
		let ret = ("".padRight(mx) + CurrentText).padRight(OutputSize)
		CurrentText = StaticText
		return ret
	}
	
	private func getNextPart() -> String {
		var ret = CurrentText.left(OutputSize)
		var len = ret.length()
		if ret.contains("\n") {
			ret = ret.before("\n")
			len = ret.length() + 1
		}
		CurrentText = CurrentText.substring(from: len)
		return ret
	}
	
	func hasMore() -> Bool {
		return CurrentText.length() > 0 && Name.length() > 0
	}
	
	func output() -> String {
		if !hasMore() {
			if Name.length() == 0 {
				return Caption.padRight(OutputSize)
			}
			return "".padRight(OutputSize)
		}
		let next = getNextPart()
		if !hasMore() {
			CurrentText = StaticText
		}
		if Name == "" {
			CurrentText = Caption
		}
		return next.padRight(OutputSize)
	}
}

extension Array where Element == ConsoleColumn {
	
	func hasData() -> Bool {
		for item in self {
			if item.hasMore() {
				return true
			}
		}
		return false
	}
	
	@discardableResult func fitToWidth(maxWidth: Int) -> Bool {
		var totalWidth = 0
		for item in self {
			totalWidth += item.MinimumSize
		}
		if totalWidth > maxWidth || self.count < 1 {
			return false
		}
		
		//Reset the output sizes
		for item in self {
			item.OutputSize = item.PreferredSize
		}
		
		
		while currentWidth() > maxWidth {
			//Get a list of columns that are able to get smaller
			let cols = self.filter { (cc) -> Bool in
				return cc.OutputSize > cc.MinimumSize
			}
			
			//In theory shouldn't process the next bit because we've worked out the minimum size
			if cols.count == 0 {
				return false
			}
			let largest = cols.max { (cc1, cc2) -> Bool in
				return cc1.OutputSize > cc2.OutputSize
				}?.OutputSize ?? 0
			let lowerItem = cols.first { (cc) -> Bool in
				return cc.OutputSize == largest
			}
			lowerItem?.OutputSize -= 1
		}
		
		return true
	}
	
	func currentWidth() -> Int {
		var totalWidth = 0
		for item in self {
			totalWidth += item.OutputSize
		}
		return totalWidth
	}
}

extension Dictionary where Key == String, Value == [String] {
	
	func toString() -> String {
		let maxRows = self.values.max { (a, b) -> Bool in
			return a.count > b.count
			}?.count ?? 0
		
		var colWidths : [Int] = []
		for key in self.keys {
			var width = self[key]?.maxWidth() ?? 0
			if width < key.length() {
				width = key.length()
			}
			colWidths.append(width)
		}
		
		var sb = ""
		let rowWidth = "\(maxRows)".length().max(3)
		sb += "Row || "
		var _keys = self.keys.map {$0}
		let endPiece = " | "
		for i in 0..<_keys.count {
			sb += _keys[i].padRight(colWidths[i])
			if i < _keys.count - 1 {
				sb += endPiece
			}
		}
		let lineLength = sb.length()
		sb += "\n" + ("-".repeating(lineLength)) + "\n"
		
		for row in 0..<maxRows {
			sb += "\(row + 1)".padRight(rowWidth)
			sb += " || "
			for col in 0..<_keys.count {
				if let values = self[_keys[col]] {
					if values.count > row {
						sb += values[row].padRight(colWidths[col])
					}
					else {
						sb += "".padRight(colWidths[col])
					}
					if col < _keys.count - 1 {
						sb += endPiece
					}
				}
			}
			sb += "\n"
		}
		return sb
	}
	
}

extension Array where Element == String {
	func maxWidth() -> Int {
		return self.max { (a, b) -> Bool in
			return a.length() > b.length()
			}?.length() ?? 0
	}
}
