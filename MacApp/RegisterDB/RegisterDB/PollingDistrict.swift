//
//  PollingDistrict.swift
//  RegisterDB
//
//  Created by Matt Hogg on 22/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common

public class PollingDistrict : TableBased<Int> {
	override public init(_ id: Int?) {
		super.init(id)
	}
	override public init() {
		super.init()
	}
	override public init(row: SQLRow) {
		super.init(row: row)
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("PollingDistrict") {
			let sql = "CREATE TABLE PollingDistrict (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, StreetCount INTEGER, PropertyCount INTEGER, ElectorCount INTEGER, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("PollingDistrict")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO PollingDistrict (Name, StreetCount, PropertyCount, ElectorCount, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: Name, StreetCount, PropertyCount, ElectorCount, _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE PollingDistrict SET SID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Name = ?, StreetCount = ?, PollingDistrict SET Name = ?, PropertyCount = ?, ElectorCount = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: Name, StreetCount, PropertyCount, ElectorCount, ID ?? _pdid, _sid, _pid, _eid)
	}
	
	public var Name = "", PropertyCount = 0, ElectorCount = 0, StreetCount = 0
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [Name, StreetCount, PropertyCount, ElectorCount, _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM PollingDistrict WHERE ID = \(ID ?? -1)")
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		super.loadData(row: row)
		Name = row.get("Name", "")
		StreetCount = Street.count(pollingDistrict: ID ?? -1)
		PropertyCount = Property.count(pollingDistrict: ID ?? -1)
		ElectorCount = Elector.count(pollingDistrict: ID ?? -1)
		
		_pdid = row.get("PDID", -1)
		_sid = row.get("SID", -1)
		_pid = row.get("PID", -1)
		_eid = row.get("EID", -1)
		_created = row.get("Created", Date())
	}
	
	public var PDID : Int? {
		get {
			return _pdid > 0 ? _pdid : nil
		}
		set {
			_pdid = newValue ?? 0
		}
	}
	
	public var SID : Int? {
		get {
			return _sid > 0 ? _sid : nil
		}
		set {
			_sid = newValue ?? 0
		}
	}
	public var PID : Int? {
		get {
			return _pid > 0 ? _pid : nil
		}
		set {
			_pid = newValue ?? 0
		}
	}
	public var EID : Int? {
		get {
			return _eid > 0 ? _eid : nil
		}
		set {
			_eid = newValue ?? 0
		}
	}
	
	override public func getChildIDs() -> [Int] {
		let sql = "SELECT ID FROM Street WHERE PDID = \(ID ?? -1) ORDER BY ID"
		return SQLDB.queryMultiRow(sql).map { (row) -> Int in
			return row.get("ID", -1)
		}
	}
	
	override public var hasChildren: Bool {
		get {
			return StreetCount > 0
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func recalculateCounts() {
		if _hasTable {
			StreetCount = Street.count(pollingDistrict: ID!)
			PropertyCount = Property.count(pollingDistrict: ID!)
			ElectorCount = Elector.count(pollingDistrict: ID!)
		}
	}
	
	public static func assertCounts() {
		let sql = "UPDATE PollingDistrict SET PropertyCount = (SELECT COUNT(*) FROM Property WHERE Property.PDID = PollingDistrict.ID)"
		SQLDB.execute(sql)
		
		let sql2 = "UPDATE PollingDistrict SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.PDID = PollingDistrict.ID)"
		SQLDB.execute(sql2)
		
		let sql3 = "UPDATE PollingDistrict SET StreetCount = (SELECT COUNT(*) FROM Street WHERE Street.PDID = Street.ID)"
		SQLDB.execute(sql3)
		
	}
	
	public func createStreet() -> Street {
		let ret = Street()
		ret.PDID = ID!
		return ret
	}
}
