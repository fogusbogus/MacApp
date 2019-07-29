//
//  Street.swift
//  RegisterDB
//
//  Created by Matt Hogg on 18/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common

public class Street : TableBased<Int> {
	override public init(_ id: Int?) {
		super.init(id)
	}
	override public init() {
		super.init()
	}
	override public init(row: SQLRow) {
		super.init(row: row)
	}
	public init(data: StreetDataStruct) {
		super.init()
		Data = data
	}
	
	public var Data : StreetDataStruct {
		get {
			return StreetDataStruct(Name: Name, PropertyCount: PropertyCount, ElectorCount: ElectorCount, Meta: MetaData.getSignature(), ID: ID, GPS: GPS, EID: EID.Nil(), PID: PID.Nil(), SID: SID.Nil(), PDID: PDID.Nil())
		}
		set {
			self.ID = newValue.ID
			self.PDID = newValue.PDID.Nil()
			self.SID = newValue.SID.Nil()
			self.PID = newValue.PID.Nil()
			self.EID = newValue.EID.Nil()
			
			self.Name = newValue.Name
			self.PropertyCount = newValue.PropertyCount
			self.ElectorCount = newValue.ElectorCount
			self.MetaData.load(json: newValue.Meta, true)
		}
	}

	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Street") {
			let sql = "CREATE TABLE Street (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, PropertyCount INTEGER, ElectorCount INTEGER, GPS TEXT, Meta TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Street")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Street (Name, PropertyCount, ElectorCount, GPS, Meta, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: Name, PropertyCount, ElectorCount, GPS, MetaData.toJson(true), _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Street SET SID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Street SET Name = ?, PropertyCount = ?, ElectorCount = ?, GPS = ?, PDID = ?, SID = ?, PID = ?, EID = ?, Meta = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: Name, PropertyCount, ElectorCount, GPS, _pdid, ID ?? _sid, _pid, _eid, MetaData.toJson(true))
	}
	
	public var Name = "", PropertyCount = 0, ElectorCount = 0, GPS = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [Name, PropertyCount, ElectorCount, GPS, MetaData.getSignature(), _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
	}
	
	public func PollingDistrictName() -> String {
		let sql = "SELECT Name FROM PollingDistrict WHERE ID = ?"
		return SQLDB.queryValue(sql, "<Unknown>", ID)
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM Street WHERE ID = \(ID ?? -1)")
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		super.loadData(row: row)
		Name = row.get("Name", "")
		PropertyCount = Property.count(street: ID ?? -1)
		ElectorCount = Elector.count(property: ID ?? -1)
		GPS = row.get("GPS", "")
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
		let sql = "SELECT ID FROM Property WHERE SID = \(ID ?? -1) ORDER BY ID"
		return SQLDB.queryMultiRow(sql).map { (row) -> Int in
			return row.get("ID", -1)
		}
	}
	
	override public var hasChildren: Bool {
		get {
			return PropertyCount > 0
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func recalculateCounts() {
		if _hasTable {
			PropertyCount = Property.count(street: ID!)
			ElectorCount = Elector.count(street: ID!)
		}
	}
	
	public static func count(pollingDistrict: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Street WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func assertCounts() {
		let sql = "UPDATE Street SET PropertyCount = (SELECT COUNT(*) FROM Property WHERE Property.SID = Street.ID)"
		SQLDB.execute(sql)

		let sql2 = "UPDATE Street SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.SID = Street.ID)"
		SQLDB.execute(sql2)
		
		let sql3 = "UPDATE Property SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.PID = Property.ID)"
		SQLDB.execute(sql3)

	}
	
	public func createProperty() -> Property {
		let ret = Property()
		ret.SID = ID!
		ret.PDID = PDID
		return ret
	}
}

public struct StreetDataStruct {
	var Name = ""
	var PropertyCount = 0
	var ElectorCount = 0
	var Meta = ""

	var ID : Int?
	var GPS = ""
	var EID : Int?
	var PID : Int?
	var SID : Int?
	var PDID : Int?
}


