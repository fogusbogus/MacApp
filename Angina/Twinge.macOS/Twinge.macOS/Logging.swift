//
//  Logging.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 06/12/2020.
//

import Foundation
import LoggingLib
import Cocoa

class BaseLog {
	static let shared = BaseLog()
	
	private init() {
	}
	
	private var _log = BaseIndentLog()
	public var Log : BaseIndentLog {
		get {
			_log.IndentLog_URL = nil
			return _log
		}
	}
}

