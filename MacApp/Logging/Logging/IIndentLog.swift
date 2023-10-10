//
//  IIndentLog.swift
//  Logging
//
//  Created by Matt Hogg on 02/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
//import Common

public protocol IIndentLog {
	var LogIndent : Int { get set }
	var LogFileURL : URL? { get set }
	
	var Log : IIndentLog? { get set }
	
	@discardableResult
	func IncreaseLogIndent() -> Int
	@discardableResult
	func DecreaseLogIndent() -> Int
	@discardableResult
	func ResetLogIndent(_ indent: Int) -> Int
	
	//func AllowLog(_ logType: LogType) -> Bool
}

public enum LogType : String {
	case Debug
	case Info
	case Checkpoint
	case Indent
	case Timed
	case Warn
	case Error
	case Fatal
	case Other
	
	func toCode() -> String {
		switch self {
		case .Checkpoint:
			return "CHK"
		case .Debug:
			return "DBG"
		case .Error:
			return "ERR"
		case .Fatal:
			return "FTL"
		case .Indent:
			return ">>>"
		case .Info:
			return "INF"
		case .Other:
			return "???"
		case .Timed:
			return "TMR"
		default:
			return "WRN"
		}
	}
	
	func fromCode(_ code: String) -> LogType {
		let code = (code + "   ").substring(from: 0, length: 3).uppercased()
		switch code {
		case "DBG":
			return .Debug
		case "CHK":
			return .Checkpoint
		case "INF":
			return .Info
		case ">>>":
			return .Indent
		case "TMR":
			return .Timed
		case "WRN":
			return .Warn
		case "ERR":
			return .Error
		case "FTL":
			return .Fatal
		default:
			return .Other
		}
	}
	
}

extension Date {
	func standardString() -> String {
		let df = DateFormatter()
		df.dateFormat = "dd/MM/yy HH:mm:ssZ"
		
		return df.string(from: Date())
	}
	
	func timeSinceString(_ startDate: Date) -> String {
		let ts = self.timeIntervalSince(startDate)
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.unitsStyle = .abbreviated
		formatter.maximumUnitCount = 1
		return formatter.string(from: ts)!
	}
}

public extension Optional where Wrapped == IIndentLog {
	
	func indent(_ title: String, _ innerCode: () -> Void) {
		if self == nil {
			innerCode()
			return
		}
		let log = self!
		let indent = log.LogIndent
		let inTS = Date()
		write(">>>", title)
		log.IncreaseLogIndent()
		innerCode()
		log.ResetLogIndent(indent)
		write("<<<", "\(title) {\(Date().timeSinceString(inTS))}")
	}
	
	func indent<T>(_ title: String, _ innerCode: () -> T) -> T {
		if self == nil {
			return innerCode()
		}
		let log = self!
		let indent = log.LogIndent
		let inTS = Date()
		write(">>>", title)
		log.IncreaseLogIndent()
		let ret = innerCode()
		log.ResetLogIndent(indent)
		write("<<<", "\(title) [\(ret)] {\(Date().timeSinceString(inTS))}")
		return ret
	}
	
	func checkpoint(_ title: String, _ innerCode: () -> Void, keyAndValues: [String:Any?]) {
		if self == nil {
			innerCode()
			return
		}
		let log = self!
		let indent = log.LogIndent
		let inTS = Date()
		args(title, keyAndValues, "CHK")
		log.IncreaseLogIndent()
		innerCode()
		log.ResetLogIndent(indent)
		write("---", "<<< \(title) {\(Date().timeSinceString(inTS))}")
	}
	
	func checkpoint<T>(_ title: String, _ innerCode: () -> T, keyAndValues: [String:Any?]) -> T {
		if self == nil {
			return innerCode()
		}
		let log = self!
		let indent = log.LogIndent
		let inTS = Date()
		args(title, keyAndValues, "CHK")
		log.IncreaseLogIndent()
		let ret = innerCode()
		log.ResetLogIndent(indent)
		write("---", "<<< \(title) [\(ret)] {\(Date().timeSinceString(inTS))}")
		return ret
	}
	
	func checkpoint(_ label: String, _ title: String, _ innerCode: () -> Void, keyAndValues: [String:Any?]) {
		self.label(label)
		if self == nil {
			innerCode()
			return
		}

		let log = self!
		let indent = log.LogIndent
		let inTS = Date()
		args(title, keyAndValues, "CHK")
		log.IncreaseLogIndent()
		innerCode()
		log.ResetLogIndent(indent)
		write("---", "<<< \(title) {\(Date().timeSinceString(inTS))}")
	}
	
	func checkpoint<T>(_ label: String, _ title: String, _ innerCode: () -> T, keyAndValues: [String:Any?]) -> T {
		if self == nil {
			return innerCode()
		}
		let log = self!
		self.label(label)
		let indent = log.LogIndent
		let inTS = Date()
		args(title, keyAndValues, "CHK")
		log.IncreaseLogIndent()
		let ret = innerCode()
		log.ResetLogIndent(indent)
		write("---", "<<< \(title) [\(ret)] {\(Date().timeSinceString(inTS))}")
		return ret
		
	}
	
	func label(_ title: String) {
		if self == nil {
			return
		}
		let lines = title.splitIntoLines(60)
		let max = lines.map { (s) -> Int in
			return s.trim().length()
		}.max() ?? 0
		blank()
		if max > 0 {
			let spaces = " ".repeating(max)
			let top = "/".repeating(max + 8)
			write("///", top, 1000, 0)
			for line in lines {
				let outline = "/// " + (line.trim() + spaces).substring(from: 0, length: max) + " ///"
				writeNoTS(outline)
			}
			writeNoTS(top)
		}
	}
	
	func blank() {
		writeNoTS("")
	}
	
	private func indentSpaces(_ indent: Int) -> String {
		return ".  ".repeating(indent)
	}
	
	private func write(_ category: String, _ message: String, _ maxLen: Int = 60, _ indentedCount : Int? = nil) {
		
		let messageLines = message.splitIntoLines(maxLen)
		var output = Date().standardString() + "  "
		let cat = (category + "   ").substring(from: 0, length: 3).uppercased()
		let indent = indentSpaces(indentedCount ?? self!.LogIndent)
		output += cat + "  " + indent
		var allOutput = ""
		var reset = false
		for line in messageLines {
			if allOutput != "" {
				allOutput += "\n"
			}
			allOutput += output + line
			if !reset {
				output = " ".repeating(output.length())
				reset = true
			}
		}
		if let url = self!.LogFileURL {
			do {
				try allOutput.appendToURL(fileURL: url)
			}
			catch {
				print(output)
			}
		}
		else {
			print(output)
		}
	}
	
	private func writeNoTS(_ message: String) {
		
		var output = Date().standardString() + "  "
		output = " ".repeating(output.length() + 5) + message

		if let url = self!.LogFileURL {
			do {
				try output.appendToURL(fileURL: url)
			}
			catch {
				print(output)
			}
		}
		else {
			print(output)
		}
	}
	
	func args(_ title: String, _ keysValues: [String:Any?], _ alternate: String = "ARG") {
		if self == nil {
			return
		}
		if title.trim().length() > 0 {
			write(alternate, title)
		}
		let maxLen = keysValues.keys.map { (k) -> Int in
			return k.trim().length()
		}.max()
		if maxLen == nil {
			return
		}
		
		for kv in keysValues {
			let k = (kv.key + " ".repeat(maxLen!)).substring(from: 0, length: maxLen!)
			if (kv.value == nil) {
				write("...", "--> \(k) : <nil>")
			}
			else {
				write("...", "--> \(k) : \(kv.value!)")
			}
		}
		write("", "")
	}
	
	func debug(_ message: String, _ arguments: [String:Any?]) {
		if self == nil {
			return
		}
		args(message, arguments, "DBG")
	}
	func debug(_ message: String, _ arguments: CVarArg...) {
		if self == nil {
			return
		}
		write("DBG", String(format: message, arguments))
	}
	
	func info(_ message: String, _ arguments: [String:Any?]) {
		if self == nil {
			return
		}
		args(message, arguments, "INF")
	}
	func info(_ message: String, _ arguments: CVarArg...) {
		if self == nil {
			return
		}
		write("INF", String(format: message, arguments))
	}
	
	func warn(_ message: String, _ arguments: [String:Any?]) {
		if self == nil {
			return
		}
		args(message, arguments, "WRN")
	}
	func warn(_ message: String, _ arguments: CVarArg...) {
		if self == nil {
			return
		}
		write("WRN", String(format: message, arguments))
	}
	
	func error(_ message: String, _ arguments: [String:Any?]) {
		if self == nil {
			return
		}
		args(message, arguments, "ERR")
	}
	func error(_ message: String, _ arguments: CVarArg...) {
		if self == nil {
			return
		}
		write("ERR", String(format: message, arguments))
	}
	
	func SQL(_ message: String, _ arguments: [String:Any?]) {
		if self == nil {
			return
		}
		args(message, arguments, "SQL")
	}
	func SQL(_ message: String, _ args: CVarArg...) {
		if self == nil {
			return
		}
		write("SQL", String(format: message, args))
	}
	
}

extension String {
	
	//Returns the (default) utf8 length of the string
	func length(encoding: String.Encoding = .utf8) -> Int {
		return lengthOfBytes(using: encoding)
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
	
	func repeating(_ noTimes: Int) -> String {
		if noTimes < 1 {
			return ""
		}
		return String(repeating: self, count: noTimes)
	}
}

extension Comparable {
	func min(_ subsequent: Self...) -> Self {
		if subsequent.count == 0 {
			return self
		}
		var ar = subsequent
		ar.append(self)
		return ar.min()!
	}
	
	func max(_ subsequent: Self...) -> Self {
		if subsequent.count == 0 {
			return self
		}
		var ar = subsequent
		ar.append(self)
		return ar.max()!
	}
	
}
