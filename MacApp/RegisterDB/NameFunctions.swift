//
//  NameFunctions.swift
//  RegisterDB
//
//  Created by Matt Hogg on 17/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class NameFunctions {
	public static func assumedForename(name: String) -> String {
		return name.before(" ", returnAllWhenMissing: true)
	}
	
	public static func assumedSurname(name: String) -> String {
		let names = name.trim().splitToArray(" ")
		if names.count > 0 {
			return names.last!
		}
		return name
	}
	
	public static func assumedMiddleNames(name: String) -> String {
		var names = name.removeMultipleSpaces(true).splitToArray(" ")
		if names.count > 0 {
			names.removeFirst()
		}
		if names.count > 0 {
			names.removeLast()
		}
		return names.joined(separator: " ")
	}
}
