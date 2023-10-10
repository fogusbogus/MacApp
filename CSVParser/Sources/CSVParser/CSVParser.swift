import Foundation

public class CSVParser {
	
	public struct Options {
		var trim = true
		var alignCount = false
		var rowSplitChars: [String] = ["\n"]
		var columnSplitChars: [String] = [","]
		var columnEscapes: [String] = ["\""]
		var allowLeadingWhitespaceBeforeEscapes = false
	}
	
	/// A column escape only applies when it begions the column value. This function counts the column escapes.
	/// - Parameters:
	///   - data: text
	///   - options: decides how we process our CSVs
	/// - Returns: True if current text is outside of column escapes
	private static func isOutsideColumnEscapes(data: String, options: Options) -> Bool {
		guard data.count > 0 else { return true }
		let compareData = options.allowLeadingWhitespaceBeforeEscapes ? data.trimmingCharacters(in: .whitespacesAndNewlines) : data
		if options.columnEscapes.contains(String(compareData.prefix(1))) {
			let chr = String(compareData.prefix(1))
			return (data.count - data.replacingOccurrences(of: chr, with: "").count) % 2 == 0
		}
		return true
	}
	
	private static func trimToColumnEscapes(text: String, options: Options) -> String {
		var text = text
		if options.allowLeadingWhitespaceBeforeEscapes {
			if options.columnEscapes.first(where: {text.trimmingLeadingSpaces().hasPrefix($0)}) != nil {
				text = text.trimmingLeadingSpaces()
			}
		}
		if options.columnEscapes.first(where: {text.hasPrefix($0)}) != nil {
			let escape = String(text.first!)
			while !text.hasSuffix(escape) {
				text.removeLast()
			}
		}
		return text
	}
	
	private static func getCSVFlatArray(csv: String, options: Options) -> [String] {
		var data : [String] = []
		var currentData = ""
		csv.forEach { c in
			let chr = String(c)
			if (options.columnSplitChars.contains(chr) || options.rowSplitChars.contains(chr)) && isOutsideColumnEscapes(data: currentData, options: options) {
				data.append(trimToColumnEscapes(text: currentData, options: options))
				currentData = ""
				if options.rowSplitChars.contains(chr) {
					data.append(chr)
				}
			}
			else {
				currentData += chr
			}
		}
		
		if csv.count > 0 {
			data.append(trimToColumnEscapes(text: currentData, options: options))
		}
		return data
	}
	
	private static func getDefaultOptions(options: Options?, usesCarriageReturn: Bool = false) -> Options {
		return options ?? Options(trim: true, alignCount: false, rowSplitChars: usesCarriageReturn ? ["\r"] : ["\n"], columnSplitChars: [","], columnEscapes: ["\""], allowLeadingWhitespaceBeforeEscapes: false)
	}
	
	private static func removeColumnEscapes(text: String, options: Options) -> String {
		var text = text
		if options.columnEscapes.contains(where: {
			if options.allowLeadingWhitespaceBeforeEscapes {
				return text.trimmingLeadingSpaces().hasPrefix($0) && text.hasSuffix($0)
			}
			return text.hasPrefix($0) && text.hasSuffix($0)
		}) {
			let escape = options.allowLeadingWhitespaceBeforeEscapes ? text.trimmingLeadingSpaces().prefix(1) : text.prefix(1)
			text = text.replacingOccurrences(of: escape + escape, with: escape)
			text.removeFirst()
			text.removeLast()
			return text
		}
		if options.trim {
			text = text.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		return text
	}
	
	private static func ensureMinimumColumnCount(array: [[String]], count: Int) -> [[String]] {
		guard count > 0 else { return array }
		var ret : [[String]] = []
		array.forEach { row in
			var row = row
			while row.count < count {
				row.append("")
			}
			ret.append(row)
		}
		return ret
	}
	
	public static func getArrayFromCSVContent(csv: String, options: Options?) -> [[String]] {
		if options?.trim ?? false && csv.trimmingLeadingSpaces().count == 0 {
			return []
		}
		let defaultOptions = getDefaultOptions(options: options, usesCarriageReturn: !csv.contains("\n"))
		var ret: [[String]] = []
		var current: [String] = []
		var maxCols = 0
		let data = getCSVFlatArray(csv: csv.replacingOccurrences(of: "\r\n", with: "\n"), options: defaultOptions)
		data.forEach { item in
			if defaultOptions.rowSplitChars.contains(item) {
				if maxCols < current.count {
					maxCols = current.count
				}
				ret.append(current)
				current.removeAll()
			}
			else {
				current.append(removeColumnEscapes(text: item, options: defaultOptions))
			}
		}
		
		//Residual data
		if current.count > 0 {
			if maxCols < current.count {
				maxCols = current.count
			}
			ret.append(current)
		}
		
		//Current requirements is for at least one column per row, even if blank
		if !defaultOptions.alignCount {
			return ensureMinimumColumnCount(array: ret, count: 1)
		}
		
		return ensureMinimumColumnCount(array: ret, count: maxCols)
	}
}


extension String {
	func trimmingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
		guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
			if self.trimmingCharacters(in: characterSet).count == 0 {
				return ""
			}
			return self
		}
		
		return String(self[index...])
	}
}

