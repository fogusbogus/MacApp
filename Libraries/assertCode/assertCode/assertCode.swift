//
//  assertCode.swift
//  replacer
//
//  Created by Matt Hogg on 23/03/2023.
//

import Foundation
import ArgumentParser
import ColorConsole

import LoggingLib

class Log : ConsoleLog {
	
}

extension String {
	func fore(_ code: ColorConsole.ConsoleColorCodes, _ option: ColorConsole.ConsoleColorCodeOption = .none) -> String {
		return code.foreground(option) + self + ConsoleColorCodes.default.foreground()
	}
	
	func back(_ code: ColorConsole.ConsoleColorCodes) -> String {
		return code.background() + self + ConsoleColorCodes.default.background()
	}
}

@main
struct AssertCode: ParsableCommand {
	
	@Argument(help: "The source file")
	var source: String
	
	@Argument(help: "The code file to insert")
	var codeFile: String
	
	@Argument(help: "The code line to find to insert after")
	var codeLine: String
	
	@Flag(name: [.customShort("c"), .long], help: "Case-sensitive")
	var `case`: Bool = false
			
	@Flag(name: [.customShort("b"), .long], help: "Backup")
	var backup: Bool = false
	
	@Flag(name: [.customShort("o"), .long], help: "Overwrite file")
	var overwrite: Bool = false
	
	@Flag(name: [.customShort("d"), .long], help: "Development mode")
	var devMode: Bool = false
	
	enum Errors : Error {
		case noSourceFile(source: String)
		case alreadyEstablished
		case codeFileNotFound(codeFile: String)
		
		func log() {
			switch self {
				case .noSourceFile(source: let source):
					Log.error("Couldn't find source file '\(source.fore(.magenta))'")
				case .alreadyEstablished:
					Log.error("Append has already been applied")
				case .codeFileNotFound(codeFile: let codeFile):
					Log.error("Couldn't find code file '\(codeFile.fore(.magenta))'")
			}
		}
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
		
		do {
			if devMode {
				Log.devMode = true
			}
			
			let replacement = "// Inserted from \(codeFile)"
			Log.log(ConsoleColorCodes.green.foreground(.underline) + "AssertCode")
			Log.paramList(["source":source, "codeFile":codeFile, "codeLine":codeFile, "backup":backup, "overwrite":overwrite, "devMode":devMode])
			
			if !FileManager.default.fileExists(atPath: source) {
				Log.error("Cannot find file '\(source)'")
				throw Errors.noSourceFile(source: source)
			}
			
			if !FileManager.default.fileExists(atPath: codeFile) {
				Log.error("Cannot find code file '\(codeFile.fore(.green))'")
				throw Errors.codeFileNotFound(codeFile: codeFile)
			}
			
			var opData : [String] = []
			Log.log("Found file '\(source.fore(.green))'")
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
			
			if let _ = lines.first(where: { $0.contains(replacement) }) {
				Log.error("Already established code line, exiting...")
				throw Errors.alreadyEstablished
			}
			
			//Let's get a temporary filename
			//let temp = getTemporaryFile()
			let find = `case` ? codeFile.trimmingCharacters(in: .whitespaces) : codeFile.lowercased().trimmingCharacters(in: .whitespaces)
			var alreadyAppended = false
			lines.forEach { line in
				//Log.log("replacement = \(replacement)")
				var match = false
				if `case` {
					match = line.trimmingCharacters(in: .whitespaces) == find
				}
				else {
					match = line.trimmingCharacters(in: .whitespaces).lowercased() == find
				}
				opData.append(line)
				if match {
					//Log.log("Found match")
					if !alreadyAppended {
						opData.append(replacement)
						let contents = try! String(contentsOfFile: source, encoding: .utf8).components(separatedBy: .newlines)
						opData.append(contentsOf: contents)
						alreadyAppended = true
					}
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
		catch let error as Errors {
			error.log()
		}
		catch {
			Log.error(error.localizedDescription)
		}
	}
}


