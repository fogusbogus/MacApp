//
//  main.swift
//  replacer
//
//  Created by Matt Hogg on 13/03/2023.
//

import Foundation
import ArgumentParser
import ColorConsole

import LoggingLib

class Log : JsonLog {
}

@main
struct Replacer: ParsableCommand {
	
	@Argument(help: "The source file")
	var source: String
	
	@Argument(help: "The line of code to find")
	var codeLine: String
	
	@Argument(help: "Replacement text")
	var replacement: String
	
	@Flag(name: [.customShort("a"), .long], help: "Append as new line instead of replace")
	var append: Bool = false
	
	@Flag(name: [.customShort("c"), .long], help: "Case-sensitive")
	var `case`: Bool = false
	
	@Flag(name: [.customShort("l"), .long], help: "Logging")
	var logging: Bool = false
	
	@Flag(name: [.customShort("b"), .long], help: "Backup")
	var backup: Bool = false
	
	@Flag(name: [.customShort("w"), .long], help: "Whole line match")
	var wholeLine: Bool = false
	
	@Flag(name: [.customShort("o"), .long], help: "Overwrite file")
	var overwrite: Bool = false
	
	@Flag(name: [.customShort("d"), .long], help: "Development mode")
	var devMode: Bool = false
	
	enum Errors : Error {
		case noSourceFile(source: String)
	}
	
	func getTemporaryFile() -> String {
		let path = FileManager.default.temporaryDirectory
		try? FileManager.default.createDirectory(atPath: path.absoluteString, withIntermediateDirectories: true)
		var file = UUID().uuidString
		while FileManager.default.fileExists(atPath: path.appending(component: file, directoryHint: .notDirectory).absoluteString) {
			file = UUID().uuidString
		}
		return path.appending(component: file, directoryHint: .notDirectory).absoluteString
	}
	
	mutating func run() throws {
		Log.path = "/Users/matt/mylog.log"
		if devMode {
			//Log.devMode = true
		}
		
		let replacement = replacement
		Log.log(ConsoleColorCodes.green.foreground(.underline) + "Replacer")
		Log.paramList(["source":source, "codeLine":codeLine, "replacement":replacement, "append":append, "case":`case`, "logging":logging, "backup":backup, "wholeLine":wholeLine, "overwrite":overwrite, "devMode":devMode])
		
		if !FileManager.default.fileExists(atPath: source) {
			Log.error("Cannot find file '\(source)'")
			throw Errors.noSourceFile(source: source)
		}
		
		var opData : [String] = []
		Log.log("Found file '\(source)'")
		if backup {
			try? FileManager.default.removeItem(atPath: URL(filePath: source).appendingPathExtension("bak").absoluteString)
			try? FileManager.default.copyItem(atPath: source, toPath: URL(filePath: source).appendingPathExtension("bak").absoluteString)
		}
		Log.log("Reading data")
		let lines = try String(contentsOfFile: source, encoding: .utf8).components(separatedBy: .newlines)
//		lines.forEach { line in
//			Log.log("->\(line)")
//		}
		Log.log("Data read")
		
		//Let's get a temporary filename
		//let temp = getTemporaryFile()
		var find = `case` ? codeLine.trimmingCharacters(in: .whitespaces) : codeLine.lowercased().trimmingCharacters(in: .whitespaces)
		if !wholeLine {
			find = codeLine
		}
		lines.forEach { line in
			//Log.log("replacement = \(replacement)")
			var match = false
			if `case` {
				if wholeLine {
					match = line.trimmingCharacters(in: .whitespaces) == find
				}
				else {
					match = line.contains(find)
				}
			}
			else {
				if wholeLine {
					match = line.trimmingCharacters(in: .whitespaces).lowercased() == find
				}
				else {
					match = line.lowercased().contains(find)
				}
			}
			if match {
				//Log.log("Found match")
				if append {
					opData.append(line)
				}
				if wholeLine {
					opData.append(replacement)
				}
				else {
					var lastRange : Range<String.Index>?
					var line = line
					while let range = line.range(of: find, options: .caseInsensitive) {
						if let previousRange = lastRange {
							if previousRange.lowerBound == range.lowerBound {
								break
							}
						}
						lastRange = range
						let substring = line[range]
						line = line.replacingOccurrences(of: substring, with: replacement)
					}
					//Log.log("Replacement line: \(line)")
					opData.append(line)
				}
			}
			else {
				opData.append(line)
			}
		}
//		opData.forEach { line in
//			Log.log("-> " + line)
//		}
		if !overwrite {
			print("Overwrite? (y/n): ")
			if readLine(strippingNewline: true)?.lowercased() == "y" {
				try FileManager.default.removeItem(atPath: source)
				let textToWrite = opData.joined(separator: "\n")
				try textToWrite.write(toFile: source, atomically: true, encoding: .utf8)
			}
		}
		else {
			try FileManager.default.removeItem(atPath: source)
			let textToWrite = opData.joined(separator: "\n")
			try textToWrite.write(toFile: source, atomically: true, encoding: .utf8)
		}
	}
}


