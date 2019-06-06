//
//  Log.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

class Log {
	static func debug(tag: String = "", text: String, _ parms: Any...) {
		print("D: {0}\t{1}".fmt(tag, text.fmt(parms)))
	}
	
	static func error(tag: String = "", text: String, _ parms: Any...) {
		print("E: {0}\t{1}".fmt(tag, text.fmt(parms)))
	}
	
	static func error(tag: String = "", error: Error, text: String = "", _ parms: Any...) {
		var newLineText = text
		if newLineText.length() > 0 {
			newLineText = "\n" + newLineText
		}
		Log.error(tag: tag, text: error.localizedDescription + newLineText, parms)
	}
	
	static func information(tag: String = "", text: String, _ parms: Any...) {
		print("I: {0}\t{1}".fmt(tag, text.fmt(parms)))
	}
	
	static func warning(tag: String = "", text: String, _ parms: Any...) {
		print("W: {0}\t{1}".fmt(tag, text.fmt(parms)))
	}
	
	static func sql(tag: String = "", text: String, _ parms: Any...) {
		print("S: {0}\t{1}".fmt(tag, text.fmt(parms)))
	}
	
	static func property(tag: String = "", obj: Any, propertyName: String, value: Any?) {
		var className = String(describing: obj.self)
		if className.length() > 0 {
			className += "::"
		}
		
		let newTag = tag + "/Set"
		let val = "[{0}{1}] --> {2}"
		var v = "null"
		if value != nil {
			v = String(describing: value)
		}
		debug(tag: newTag, text: val.fmt(propertyName, v))
	}
}
