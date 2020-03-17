//
//  PollingDistrict.swift
//  RegisterDB
//
//  Created by Matt Hogg on 22/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import LoggingLib

public class PollingDistrict : TableBased<Int>, KeyedItem {
	public static func getCalculatedName(db: SQLDBInstance, id: Int) -> String {
		return db.queryValue("SELECT DisplayName FROM PollingDistrict WHERE ID = ? LIMIT 1", "", id)
	}
	
	public var Key: String {
		get {
			return "PD\(ID!)"
		}
	}
	
	public static func getChildrenIDs(db: SQLDBInstance, id: Int) -> [Int] {
		let sql = "SELECT ID FROM Street WHERE PDID = ? ORDER BY ID"
		return db.queryList(sql, hintValue: 0, parms: id)

	}
	
	override public init(db : SQLDBInstance, _ id: Int?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("PollingDistrict") {
			let sql = "CREATE TABLE PollingDistrict (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, StreetCount INTEGER, PropertyCount INTEGER, ElectorCount INTEGER, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("PollingDistrict")
			SQLDB.assertIndex(indexName: "idxPollingDistrictIDs", table: "PollingDistrict", fields: ["PDID", "SID", "PID", "EID"])
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO PollingDistrict (Name, StreetCount, PropertyCount, ElectorCount, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?)"
		_id = SQLDB.execute(sql, parms: Name, StreetCount, PropertyCount, ElectorCount, _pdid, _sid, _pid, _eid, Date())
		SQLDB.execute("UPDATE PollingDistrict SET SID = \(_id ?? -1) WHERE ID = \(_id ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Name = ?, StreetCount = ?, PollingDistrict SET Name = ?, PropertyCount = ?, ElectorCount = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: Name, StreetCount, PropertyCount, ElectorCount, ID ?? _pdid, _sid, _pid, _eid)
	}
	
	public var Name = "", PropertyCount = 0, ElectorCount = 0, StreetCount = 0
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any?] {
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
		StreetCount = Street.count(db: SQLDB, pollingDistrict: ID ?? -1)
		PropertyCount = Property.count(db: SQLDB, pollingDistrict: ID ?? -1)
		ElectorCount = Elector.count(db: SQLDB, pollingDistrict: ID ?? -1)
		MetaData.load(json: row.get("Meta", ""), true)

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
	
	public func recalculateCounts() {
		if _hasTable {
			StreetCount = Street.count(db: SQLDB, pollingDistrict: ID!)
			PropertyCount = Property.count(db: SQLDB, pollingDistrict: ID!)
			ElectorCount = Elector.count(db: SQLDB, pollingDistrict: ID!)
		}
	}
	
	public static func assertCounts(db: SQLDBInstance) {
		let sql = "UPDATE PollingDistrict SET PropertyCount = (SELECT COUNT(*) FROM Property WHERE Property.PDID = PollingDistrict.ID)"
		db.execute(sql)
		
		let sql2 = "UPDATE PollingDistrict SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.PDID = PollingDistrict.ID)"
		db.execute(sql2)
		
		let sql3 = "UPDATE PollingDistrict SET StreetCount = (SELECT COUNT(*) FROM Street WHERE Street.PDID = Street.ID)"
		db.execute(sql3)
		
		//Streets
		let sql4 = "UPDATE Street SET PropertyCount = (SELECT COUNT(*) FROM Property WHERE Property.SID = Street.ID)"
		db.execute(sql4)

		let sql5 = "UPDATE Street SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.SID = Street.ID)"
		db.execute(sql5)
		
		//Properties
		let sql6 = "UPDATE Property SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.PID = Property.ID)"
		db.execute(sql6)

	}
	
	override public func reassertCounts() {
		ElectorCount = SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = ?", 0, ID!)
		PropertyCount = SQLDB.queryValue("SELECT COUNT(*) FROM Property WHERE PDID = ?", 0, ID!)
		StreetCount = SQLDB.queryValue("SELECT COUNT(*) FROM Street WHERE PDID = ?", 0, ID!)
	}

	
	public func createStreet() -> Street {
		let ret = Street(db: SQLDB)
		ret.PDID = ID!
		return ret
	}
	
	public func GetStreets() -> [Street] {
		let rows = SQLDB.queryMultiRow("SELECT * FROM Street WHERE PDID = ? ORDER BY SID", ID!)
		var ret : [Street] = []
		for row in rows {
			ret.append(Street(db: SQLDB, row: row))
		}
		return ret
	}
	
	public func GetProperties() -> [Property] {
		let rows = SQLDB.queryMultiRow("SELECT * FROM Property WHERE PDID = ? ORDER BY SID, PID", ID!)
		var ret : [Property] = []
		for row in rows {
			ret.append(Property(db: SQLDB, row: row))
		}
		return ret
	}

}
