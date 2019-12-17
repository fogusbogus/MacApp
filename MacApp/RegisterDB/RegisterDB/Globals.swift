//
//  Globals.swift
//  RegisterDB
//
//  Created by Matt Hogg on 01/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common
import Logging

class Globals {
	static let shared = Globals()
	
	private init() {
	}
	
	public var Log : IIndentLog? = nil
	
	private var _values : [String:String] = [:]
	
	private var _db : SQLDBInstance? = nil
	
	public var DB : SQLDBInstance? {
		get {
			return _db
		}
		set {
			if _db == nil && newValue != nil {
				_db = newValue
				
				let sql = "CREATE TABLE IF NOT EXISTS Constants (ID TEXT PRIMARY KEY, Value TEXT)"
				_db?.execute(sql)
				_db?.processMultiRow(rowHandler: { (row) in
					_values[row.get("ID", "")] = row.get("Value", "")
				}, "SELECT * FROM Constants")
			}
		}
	}
	
	subscript(id: String) -> String {
		get {
			let key = _values.keys.first { (s) -> Bool in
				return s.implies(id)
			} ?? id
			return _values[key] ?? ""
		}
		set {
			let key = _values.keys.first { (s) -> Bool in
				return s.implies(id)
			} ?? id
			_values[key] = newValue
			let sql = "INSERT OR REPLACE INTO Constants (ID, Value) VALUES (?, ?)"
			_db?.execute(sql, parms: id, newValue)
		}
	}
	
	func get<T>(_ id: String, _ defaultValue: T) -> T {
		let key = _values.keys.first { (s) -> Bool in
			return s.implies(id)
		}
		if key != nil {
			return _values[key!] as! T
		}
		return defaultValue

	}
	
	func aliases(code: String) -> String {
		var ds : [String] = []
		ds.append(code.uppercased())
		
		let items = self["CODEALIAS"].splitToArray("~")
		for item in items {
			if item.contains("=") {
				let key = item.before("=")
				let value = item.after("=")
				
				if key.implies(code) {
					ds.append(value)
				}
				if value.implies(code) {
					ds.append(key)
				}
			}
		}
		return ds.toDelimitedString(delimiter: "','")
	}
	
	var defaultNationality : String {
		get {
			return get("defaultnationality", "British")
		}
	}
	
	private var _reqSync : Bool? = nil
	public func requiresSync() -> Bool {
		if _reqSync == nil {
			let count = DB?.queryValue("SELECT COUNT(*) FROM Action WHERE IFNULL(INT_ID, '') = '' AND Retract <> 1 AND IFNULL(SupersedeID, 0) < 1", 0)
			_reqSync = count! > 0
		}
		return _reqSync!
	}
	
	public func refreshSyncStatus() {
		_reqSync = nil
	}
	
	public var splitCount : Int {
		get {
			return get("SPLITCOUNT", 0)
		}
		set {
			self["SPLITCOUNT"] = "\(newValue)"
		}
	}
}
