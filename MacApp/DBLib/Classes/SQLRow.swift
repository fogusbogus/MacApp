//
//  SQLRow.swift
//  DBLib
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

import SQLite3

public class SQLRow {
	
	public var RowChangedHandler : SQLRowChangedDelegate? = nil
	
	public typealias SQLitePointer = OpaquePointer
	
	public typealias Long = Int64
	private var _data : [String:Any?] = [:]
	private var _keyMap : [String:String] = [:]
	private var _signature : String = ""
	private var _isDirty = false
	
	private func getSignature() -> String {
		var ret = ""
		let keys = _keyMap.keys.sorted()
		for key in keys {
			ret += key + "\t"
			if _data[key] == nil {
				ret += "nil"
			}
			else {
				ret += "\"\(String(describing: _data[key]))\""
			}
		}
		return ret
	}
	
	public func columns(ignoringColumns: String...) -> [String] {
		var ret : [String] = []
		var lcCols : [String] = []
		for item in ignoringColumns {
			lcCols.append(item.lowercased())
		}
		
		for key in _keyMap.keys {
			if !lcCols.contains(key) {
				ret.append(key)
			}
		}
		
		return ret
	}
	
	var IsEmpty: Bool {
		return _data.count == 0
	}
	
	public init(columnDefinitions: [String:String]) {
		
	}
	
	public init() {
	}
	
	public init(sqlData: SQLitePointer?, columnsOnly: Bool = false) {
		let colCount = sqlite3_column_count(sqlData)
		
		for i in 0..<colCount {
			let colName = String(cString: sqlite3_column_name(sqlData, i))
			if !columnsOnly {
				if sqlData.isNull(index: i)
				{
					_data[colName] = nil
				}
				else {
					switch sqlite3_column_type(sqlData, i) {
					case SQLITE_INTEGER:
						_data[colName] = sqlite3_column_int(sqlData, i)
						break
					case SQLITE_BLOB:
						_data[colName] = sqlite3_column_blob(sqlData, i)
						break
					case SQLITE_FLOAT:
						_data[colName] = sqlite3_column_double(sqlData, i)
						break
					case SQLITE_TEXT:
						let ptr = sqlite3_column_text(sqlData, i)
						_data[colName] = String(cString: ptr!)
					case SQLITE_NULL:
						_data[colName] = nil
						break
					default:
						break
					}
					//_data[colName] = sqlite3_column_value(sqlData, i)
				}
			}
			else {
				_data[colName] = nil
			}
			_keyMap[colName.lowercased()] = colName
		}
		_signature = getSignature()
	}
	
	public var createNewKeys = false
	
	//We are not using case-sensitive keys. However, the collection does, so provide
	//a way to reference a key without worrying about the case.
	private func mapID(_ id: String) -> String {
		guard _keyMap[id.lowercased()] != nil else {
			if createNewKeys {
				_keyMap[id.lowercased()] = id
				return id
			}
			return id
		}
		return _keyMap[id.lowercased()]!
	}
	
	//Has the data been changed, or an attempt to change the data. To check for differences, use
	//Signature
	public var isDirty : Bool {
		get {
			return _isDirty //_signature != getSignature()
		}
	}
	
	public func signature(original: Bool = false) -> String {
		if original {
			return _signature
		}
		return getSignature()
	}
	
	public func resetDirty() {
		_isDirty = false
	}
	
	public func hasKey(_ id: String) -> Bool {
		guard _keyMap[id.lowercased()] != nil else {
			return false
		}
		return true
	}
	public func hasKey(_ id: CodingKey) -> Bool {
		return hasKey(id.stringValue)
	}
	
	public func set<T>(_ id: CodingKey, _ newValue: T?) {
		set(id.stringValue, newValue)
	}
	public func set<T>(_ id: String, _ newValue: T?) {
		if hasKey(id) {
			//Something might want to block the update
			if let rch = RowChangedHandler {
				if !rch.beforeValueChange(column: id, newValue: newValue) {
					return
				}
			}
			_data[mapID(id)] = newValue
			
			//I don't care if it's a different value or not I do care that I've tried
			//to set it
			_isDirty = true
			
			//Something might want to know a value is being set
			if let rch = RowChangedHandler {
				rch.afterValueChange(column: id, newValue: newValue)
			}
		}
	}
	
	subscript(id: String) -> String {
		get {
			return get(id, "")
		}
		set {
			set(id, newValue)
		}
	}
	subscript(key: CodingKey) -> String {
		get {
			return get(key, "")
		}
		set {
			set(key, newValue)
		}
	}
	
	subscript<T>(id: String, defaultValue: T) -> T {
		get {
			return get(id, defaultValue)
		}
		set {
			set(id, newValue)
		}
	}
	subscript<T>(key: CodingKey, defaultValue: T) -> T {
		get {
			return get(key, defaultValue)
		}
		set {
			set(key, newValue)
		}
	}
	
	public func get<T>(_ id: CodingKey, _ defaultValue: T) -> T {
		return get(id.stringValue, defaultValue)
	}
	public func get<T>(_ id: String, _ defaultValue: T) -> T {
		if hasKey(id) {
			if isNull(id) {
				return defaultValue
			}
			if defaultValue is Int {
				if let vInt = _data[mapID(id)] as? Int {
					return vInt as! T
				}
				if let v = _data[mapID(id)] as? Int32 {
					return Int(v) as! T
				}
				if let v64 = _data[mapID(id)] as? Int64 {
					return Int(v64) as! T
				}
				return defaultValue
			}
			if let ret = _data[mapID(id)] as? T {
				return ret
			}
		}
		return defaultValue
	}
	
	//    private func getTryInt(id: String) throws -> Int {
	//
	//    }
	
	
	public func isNull(_ id: String) -> Bool {
		let mid = mapID(id)
		guard _data[mid] != nil else {
			return true
		}
		return _data[mid]! == nil
	}
	public func isNull(_ id: CodingKey) -> Bool {
		return isNull(id.stringValue)
	}
	
	public func toJsonString() -> String {
		if let ret = toJsonObject() {
			return String(data: ret, encoding: .utf8)!
		}
		return ""
	}
	
	private func toJsonObject() -> Data? {
		do {
			return try JSONSerialization.data(withJSONObject: _data, options: .prettyPrinted)
		}
		catch {
			return nil
		}
	}
}

public protocol SQLRowChangedDelegate : class {
	func beforeValueChange(column: String, newValue: Any?) -> Bool
	func afterValueChange(column: String, newValue: Any?)
}

public extension Array where Element == SQLRow {
	func columns() -> [String] {
		if self.count > 0 {
			return self[0].columns()
		}
		return []
	}
	
	func toJsonString() -> String {
		var ret = "{ rows: ["
		var first = true
		for row in self {
			if !first {
				ret += ", "
			}
			else {
				first = false
			}
			ret += row.toJsonString()
		}
		ret += "] }"
		return ret
	}
}
