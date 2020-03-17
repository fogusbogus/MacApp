//
//  Functions.swift
//  RegisterDB
//
//  Created by Matt Hogg on 28/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB

class Functions {
	public static func translateToLinkType(type: String) -> Int {
		return type.lowercased().match(defaultValue: -1, pairs: ["st":0, "pr":1, "el":2])
	}
	
	public static func getLinkTypeAndId(link: String) -> (prefix: String, linkType: LinkType, linkID: Int) {
		let id = link.keep("1234567890")
		var lt = LinkType.elector
		lt.parse(link: link)
		return (prefix: lt.type, linkType: lt, linkID: Int(id) ?? -1)
	}
}

public enum LinkType : Int {
	case street = 0
	case property = 1
	case elector = 2
	
	@discardableResult
	mutating func parse(link: String) -> LinkType {
		
		let stype = link.keep("QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
		type = stype.uppercased()
		return self
	}
	
	var intValue : Int {
		get {
			return self.rawValue
		}
		set {
			switch newValue {
			case 0:
				self = .street
				break
			case 1:
				self = .property
				break
			case 2:
				self = .elector
				break
			default:
				break
			}
		}
	}
	
	func create(db: SQLDBInstance, link: String) -> TableBased<Int> {
		let id = Int(link.keep("1234567890")) ?? -1
		var lt = LinkType.elector
		lt.parse(link: link)
		return lt.create(db: db, id: id)
	}
	
	func create(db: SQLDBInstance, id: Int) -> TableBased<Int> {
		if self == .street {
			return Street(db: db, id)
		}
		if self == .property {
			return Property(db: db, id)
		}
		return Elector(db: db, id)
	}
	
	var type : String {
		get {
			switch self {
			case .street:
				return "ST"
			case .property:
				return "PR"
			default:
				return "EL"
			}
		}
		set {
			switch newValue {
			case "ST":
				self = .street
				break
			case "PR":
				self = .property
				break
			default:
				self = .elector
				break
			}
		}
	}
}

extension Dictionary where Key == String {
	func toJsonString() -> String {
		if let ret = toJsonObject() {
			return String(data: ret, encoding: .utf8)!
		}
		return ""
	}
	
	private func toJsonObject() -> Data? {
		do {
			return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
		}
		catch {
			return nil
		}
	}
}
