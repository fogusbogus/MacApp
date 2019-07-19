//
//  Elector.swift
//  RegisterDB
//
//  Created by Matt Hogg on 19/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common

class Elector : TableBased<Int> {
	override init(_ id: Int?) {
		super.init(id)
	}
	override init() {
		super.init()
	}

	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Elector") {
			let sql = "CREATE TABLE Elector (ID INTEGER PRIMARY KEY AUTOINCREMENT, DisplayName TEXT, Surname TEXT, Forename TEXT, MiddleName TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Elector")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Elector (DisplayName, Surname, Forename, MiddleName, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Elector SET EID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Elector SET DisplayName = ?, Surname = ?, Forename = ?, MiddleName = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, _pdid, _sid, _pid, ID ?? _eid)
	}
	
	public var DisplayName = "", Surname = "", Forename = "", MiddleName = ""
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [DisplayName, Surname, Forename, MiddleName, _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM Elector WHERE ID = \(ID ?? -1)")
		DisplayName = data.get("DisplayName", "")
		Surname = data.get("Surname", "")
		Forename = data.get("Forename", "")
		MiddleName = data.get("MiddleName", "")
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
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE SID = \(street)", 0)
	}
	
	public static func count(property: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PID = \(property)", 0)
	}
	
	
}
