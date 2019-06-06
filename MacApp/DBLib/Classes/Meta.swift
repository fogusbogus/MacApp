//
//  Meta.swift
//  DBLib
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class Meta {
	
	public static func toJson(_ args: Any?...) -> String {
		var dict: [String:Any] = [:]
		var isKey = true
		var key = ""
		for arg in args {
			if isKey {
				key = "\(arg!)"
			}
			else {
				if let a = arg {
					dict[key] = "\(a)"
				}
				else {
					dict[key] = "{NULL}"
				}
			}
			isKey = !isKey
		}
		do {
			let ret = try JSONSerialization.data(withJSONObject: dict)
			if let string = String(data: ret, encoding: String.Encoding.utf8) {
				return string
			}
			return ""
		}
		catch {
			print(error.localizedDescription)
			return ""
		}
	}
	
	public static func toJson(_ args: [Any?]) -> String {
		var dict: [String:Any] = [:]
		var isKey = true
		var key = ""
		for arg in args {
			if isKey {
				key = "\(arg!)"
			}
			else {
				if let a = arg {
					dict[key] = a
				}
				else {
					dict[key] = "{NULL}"
				}
			}
			isKey = !isKey
		}
		do {
			let ret = try JSONSerialization.data(withJSONObject: dict)
			if let string = String(data: ret, encoding: String.Encoding.utf8) {
				return string
			}
			return ""
		}
		catch {
			print(error.localizedDescription)
			return ""
		}
	}
}
