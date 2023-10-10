import UIKit

var greeting = "Hello, playground"

extension String {
	func after(_ afterThis: String, allIfMissing: Bool = false) -> String {
		var parts = self.split(separator: afterThis)
		if parts.count > 0 {
			parts.removeFirst()
			return parts.joined(separator: afterThis)
		}
		if allIfMissing {
			return self
		}
		return ""
	}

	func before(_ beforeThis: String, allIfMissing: Bool = false) -> String {
		var parts = self.split(separator: beforeThis)
		if parts.count > 0 {
			return "\(parts.first!)"
		}
		if allIfMissing {
			return self
		}
		return ""
	}
	
	func trim() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

func collectNextColumn(data: String, allowLeadingWhitespaces: Bool = false) -> (data: String, columnData: String, newRow: Bool) {
	var columnEscapes: [String] = ["\""]
	var rowEscapes: [String] = ["\n"]
	var columnSeparators: [String] = [","]
	var firstChar: String = String(allowLeadingWhitespaces ? data.trim().prefix(1) : data.prefix(1))
	let removeOuterEscapes = columnEscapes.contains(firstChar)
	
	var quoted = false
	var ret = (data: "", columnData: "", newRow: false)
	var data = data
	while data.count > 0 {
		var thisChar = String(data.prefix(1))
		data = String(data.suffix(data.count - 1))
		var nextValidChar = String(data.trim().suffix(data.count - 1))
		if quoted && columnEscapes.contains(thisChar) && !columnSeparators.contains(nextValidChar) && !rowEscapes.contains(nextValidChar) && nextValidChar.count > 0 {
			ret.columnData += thisChar
			ret.newRow = rowEscapes.contains(nextValidChar)
			ret.data = data.after(nextValidChar)
		}
		else {
			if columnEscapes.contains(thisChar) {
				quoted = !quoted
			}
			else {
				if columnSeparators.contains(thisChar) || rowEscapes.contains(thisChar) {
					ret.newRow = rowEscapes.contains(thisChar)
					break
				}
			}
		}
	}
	
	return ret
}

let a = "This is a \" String with a quote in it, next column"

let b = collectNextColumn(data: a)
print(b.columnData)
print(b.data)
print(b.newRow)

