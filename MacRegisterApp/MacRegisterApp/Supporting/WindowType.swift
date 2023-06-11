//
//  WindowType.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation

class WindowType : Comparable {
	static func < (lhs: WindowType, rhs: WindowType) -> Bool {
		return lhs.key < rhs.key
	}
	
	static func == (lhs: WindowType, rhs: WindowType) -> Bool {
		return lhs.key == rhs.key
	}
	
	init(type: MenuItemIdentifier, object: any Identifiable) {
		self.type = type
		self.object = object
	}
	private(set) var type: MenuItemIdentifier
	private(set) var object: any Identifiable
	
	var key: String {
		get {
			return "\(type.actionCode.lowercased())_\(object.id)"
		}
	}
}

