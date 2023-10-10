//
//  General+Extensions.swift
//  Journal-DataModel
//
//  Created by Matt Hogg on 13/05/2022.
//

import Foundation

public extension Array where Element : Versioned {
	func reduceToLatestVersion() -> [Element] {
		var ret : [Element] = []
		self.forEach { v in
			ret.append(self.filter { other in return other.objectID == v.objectID }.max { v1, v2 in
				return v1.version > v2.version
			} ?? v)
		}
		return ret
	}
}

internal extension String {
	func implies(_ doesItLookLikeThis: String...) -> Bool {
		for item in doesItLookLikeThis {
			if self.caseInsensitiveCompare(item) == .orderedSame {
				return true
			}
		}
		return false
	}
}
