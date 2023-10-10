//
//  Lookup.swift
//  ImportData
//
//  Created by Matt Hogg on 23/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions
import SQLDB

class Lookup {
	
	var _db : SQLDBInstance? = nil
	var dict : [Int:String] = [:]
	var tableName : String = ""
	var column: String = ""
	
	init(db: SQLDBInstance, name: String, column: String = "name") {
		_db = db
		tableName = name
		self.column = column
		
		let sql = "SELECT ID, [\(column)] FROM [\(tableName)]"
		db.processMultiRow(rowHandler: { (row) in
			dict[row.get("ID", -1)] = row.get(column, "")
		}, sql)
	}
	
	//
	func lookupID(name: String) -> (Int, Bool) {
		if let item = dict.first(where: { (key, value) -> Bool in
			return value.implies(name)
		}) {
			return (item.key, false)
		}
		if let db = _db {
			let id = db.execute("INSERT INTO [\(tableName)] ([\(column)]) VALUES (?)", parms: name)
			dict[id] = name
			return (id, true)
		}
		return (-1, false)
	}
}
