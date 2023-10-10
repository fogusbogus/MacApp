//
//  QuerySQL.swift
//  SQLComms
//
//  Created by Matt Hogg on 17/01/2023.
//

import SwiftUI
import LoggingLib
import Foundation

class Log : ConsoleLog {}

class QuerySQL {
	static func shell(_ command: String) -> String {
		return Log.return {
			
			Log.log("Create the process and collect the output")
			let task = Process()
			let pipe = Pipe()
			
			task.standardOutput = pipe
			task.standardError = pipe
			task.arguments = ["-c", command]
			task.launchPath = "/bin/zsh"
			task.standardInput = nil
			task.launch()
			
			let data = pipe.fileHandleForReading.readDataToEndOfFile()
			let output = String(data: data, encoding: .utf8)!
			
			return output
			
		} pre: {
			Log.log("shell \(command)")
		} post: { value in
			Log.log("= \(value)")
		}
		
	}
	
}
