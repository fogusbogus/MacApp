//
//  BaseLog.swift
//  Common
//
//  Created by Matt Hogg on 07/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

//enum LogOutputFormat {
//	case json
//	case xml
//	case text
//}
//
//class BaseLog {
//	internal var Active = true
//
//	private var _username = ""
//	private var _maxLineWidth = -1
//	public func maxLineWidth(logDelegate: ILogDelegate? = nil) -> Int {
//		if _maxLineWidth < 0 {
//			_maxLineWidth = logDelegate?.getMaxLogLineWidth() ?? -1
//		}
//		return _maxLineWidth
//	}
//
//	private var _howToOutput : LogOutputFormat = .text
//
//	private var _backupFirst = true
//
//	private func getLogFile(logDelegate: ILogDelegate? = nil) {
//		var originalFilename = defaultFile(logDelegate: logDelegate)
//		if _backupFirst {
//			_backupFirst = false
//			backupFile(originalFilename)
//		}
//	}
//}
