//
//  Log.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 26/08/2023.
//

import LoggingLib
import Foundation

class Log : CompactLog {
	var compactLogMessageHandler = MyLogHandler()
}

class MyLogHandler: LogHandler {
	func logMessage(compactLogMessage: String) {
//		let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//		let file = docDir.appendingPathComponent("SimpleTODO.log")
//		//TODO: Put this into a file or database
//		if let handler = FileHandle(forWritingAtPath: file.path) {
//			defer {
//				try? handler.close()
//			}
//			_ = try? handler.seekToEnd()
//			handler.write(compactLogMessage.data(using: .utf8)!)
//
//		}
//		else {
//			try? compactLogMessage.write(to: file, atomically: true, encoding: .utf8)
//		}
		debugPrint(compactLogMessage)
	}
	
	
}
