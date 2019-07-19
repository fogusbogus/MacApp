//
//  Property.swift
//  RegisterDB
//
//  Created by Matt Hogg on 19/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common

class Property : TableBased<Int> {
	override init(_ id: Int?) {
		super.init(id)
	}
	override init() {
		super.init()
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Property") {
			let sql = "CREATE TABLE Property (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Number INTEGER, NumberPrefix TEXT, NumberSuffix TEXT, ElectorCount INTEGER, GPS TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Property")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Elector (Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Property SET PID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Property SET Name = ?, Number = ?, NumberPrefix = ?, NumberSuffix = ?, ElectorCount = ?, GPS = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, ID ?? _eid)
	}
	
	public var Name = "", Number = 0, NumberPrefix = "", NumberSuffix = "", ElectorCount = 0, GPS = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM Property WHERE ID = \(ID ?? -1)")
		Name = data.get("Name", "")
		Number = data.get("Number", 0)
		NumberPrefix = data.get("NumberPrefix", "")
		NumberSuffix = data.get("NumberSuffix", "")
		ElectorCount = Elector.count(property: ID ?? -1)
		GPS = data.get("GPS", "")
		
		_pdid = data.get("PDID", -1)
		_sid = data.get("SID", -1)
		_pid = data.get("PID", -1)
		_eid = data.get("EID", -1)
		_created = data.get("Created", Date())
	}
	
	var PDID : Int? {
		get {
			return _pdid > 0 ? _pdid : nil
		}
		set {
			_pdid = newValue ?? 0
		}
	}
	
	var SID : Int? {
		get {
			return _sid > 0 ? _sid : nil
		}
		set {
			_sid = newValue ?? 0
		}
	}
	var PID : Int? {
		get {
			return _pid > 0 ? _pid : nil
		}
		set {
			_pid = newValue ?? 0
		}
	}
	var EID : Int? {
		get {
			return _eid > 0 ? _eid : nil
		}
		set {
			_eid = newValue ?? 0
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func count(district: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = \(district)", 0)
	}
	
	public static func count(street: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Property WHERE SID = \(street)", 0)
	}

	public func createElector() -> Elector {
		let ret = Elector()
		ret.PID = ID!
		return ret
	}
}
