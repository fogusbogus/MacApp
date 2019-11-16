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
import Logging

public class Elector : TableBased<Int> {
	override public init(_ id: Int?, _ log: IIndentLog? = nil) {
		super.init(id, log)
	}
	override public init(_ log: IIndentLog? = nil) {
		super.init(log)
	}
	override public init(row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(row: row, log)
	}
	public init(data: ElectorDataStruct, _ log: IIndentLog? = nil) {
		super.init(log)
		Data = data
	}

	public var Data : ElectorDataStruct {
		get {
			return ElectorDataStruct(ID: ID, EID: EID.Nil(), PID: PID.Nil(), SID: SID.Nil(), PDID: PDID.Nil(), displayName: DisplayName, forename: Forename, middleName: MiddleName, surname: Surname, meta: MetaData.getSignature(true), markers: Markers)
		}
		set {
			self.ID = newValue.ID
			self.Forename = newValue.Forename
			self.MiddleName = newValue.MiddleName
			self.Surname = newValue.Surname
			self.MetaData.load(json: newValue.Meta, true)
			self.Markers = newValue.Markers
			self.PDID = newValue.PDID.Nil()
			self.SID = newValue.SID.Nil()
			self.PID = newValue.PID.Nil()
			self.EID = newValue.EID.Nil()
			handler?.dataChanged()
		}
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Elector") {
			let sql = "CREATE TABLE Elector (ID INTEGER PRIMARY KEY AUTOINCREMENT, DisplayName TEXT, Surname TEXT, Forename TEXT, MiddleName TEXT, Meta TEXT, Markers TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Elector")
			SQLDB.assertIndex(indexName: "idxElectorIDs", table: "Elector", fields: ["PDID", "SID", "PID", "EID"])
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Elector (DisplayName, Surname, Forename, MiddleName, Meta, Markers, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, MetaData.getSignature(true), Markers, _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Elector SET EID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Elector SET DisplayName = ?, Surname = ?, Forename = ?, MiddleName = ?, Meta = ?, Markers = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, MetaData.getSignature(true), Markers, _pdid, _sid, _pid, ID ?? _eid)
	}
	
	public var DisplayName = "", Surname = "", Forename = "", MiddleName = "", Markers = ""
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [DisplayName, Surname, Forename, MiddleName, MetaData.getSignature(), Markers, _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
	}
	
	public func getDisplayName() -> String {
		return "\(Forename) \(getMiddleInitials()) \(Surname)".removeMultipleSpaces(true)
	}
	
	public func getMiddleInitials() -> String {
		let parts = MiddleName.components(separatedBy: .whitespacesAndNewlines)
		var ret = ""
		parts.filter { (s) -> Bool in
			return s.trim().length() > 0
			}.forEach { (s) in
				ret += " " + s.trim().left(1).uppercased()
			}
		return ret.trim()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM Elector WHERE ID = \(ID ?? -1)")
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		DisplayName = row.get("DisplayName", "")
		Surname = row.get("Surname", "")
		Forename = row.get("Forename", "")
		MiddleName = row.get("MiddleName", "")
		Markers = row.get("Markers", "")
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
	
	override public var MetaData: ElectorMeta {
		get {
			_metaData = _metaData ?? ElectorMeta()
			return _metaData as! ElectorMeta
		}
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func count(pollingDistrict: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func count(street: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE SID = \(street)", 0)
	}
	
	public static func count(property: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PID = \(property)", 0)
	}
	
	public static func getParentageDisplayInformation(id: Int) -> [String:String] {
		let row = SQLDB.querySingleRow("SELECT EL.DisplayName AS ELName, PR.DisplayName AS PRName, ST.Name AS STName, PD.Name AS PDName FROM Elector EL LEFT JOIN Property PR ON EL.PID = PR.ID LEFT JOIN Street ST ON EL.SID = ST.ID LEFT JOIN PollingDistrict PD ON EL.PDID = PD.ID WHERE EL.ID = ?", id)
		
		var ret : [String:String] = [:]
		ret["el"] = row.get("ELName", "")
		ret["pr"] = row.get("PRName", "")
		ret["st"] = row.get("STName", "")
		ret["pd"] = row.get("PDName", "")
		return ret
	}
}

public struct ElectorDataStruct {
	public init(ID: Int?, EID: Int?, PID: Int?, SID: Int?, PDID: Int?, displayName: String, forename: String, middleName: String, surname: String, meta: String, markers: String) {
		self.ID = ID
		self.EID = EID
		self.PID = PID
		self.SID = SID
		self.PDID = PDID
		DisplayName = displayName
		Forename = forename
		MiddleName = middleName
		Surname = surname
		Meta = meta
		Markers = markers
	}
	
	public init() {
		
	}
	
	public var DisplayName = "", Forename = "", MiddleName = "", Surname = "", Meta = "", Markers = ""
	
	public var ID : Int?
	public var EID : Int?
	public var PID : Int?
	public var SID : Int?
	public var PDID : Int?
	
	public mutating func readyNextElector() {
		self.ID = nil
		self.EID = nil
		DisplayName = ""
		Forename = ""
		MiddleName = ""
		Meta = ""
		Markers = ""
	}
	
	public func getDisplayInformation() -> [String:String] {
		if let elid = ID {
			return Elector.getParentageDisplayInformation(id: elid)
		}
		return [:]
	}
}
