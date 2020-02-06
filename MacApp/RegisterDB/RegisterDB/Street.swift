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
import Logging
import MapKit

public class Street : TableBased<Int>, HasTODOItems, KeyedItem, LocatableItem, Iconised {
	public func getCoord() -> CLLocationCoordinate2D {
		if GPS.length() == 0 {
			return CLLocationCoordinate2D()
		}
		return CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
	}

	public static func getCalculatedName(db: SQLDBInstance, id: Int) -> String {
		return db.queryValue("SELECT DisplayName FROM Street WHERE ID = ? LIMIT 1", "", id)
	}
	
	public static func getChildrenIDs(db: SQLDBInstance, id: Int) -> [Int] {
		let sql = "SELECT ID FROM Property WHERE SID = ? ORDER BY ID"
		return db.queryList(sql, hintValue: 0, parms: id)
	}
	
	public static func calculateIcon(db: SQLDBInstance, id: Int) -> String {
		var sql = "SELECT COUNT(*) FROM Action WHERE SID = ? OR (LinkType = 0 AND LinkID = ?) AND Required = '1'"
		let totalTODO = db.queryValue(sql, 0, id, id)
		
		sql = "SELECT COUNT(*) FROM Action WHERE SID = ? OR (LinkType = 0 AND LinkID = ?) AND Required = '1' AND Retract <> 1"
		let totalTODOFulfilled = db.queryValue(sql, 0, id, id)
		
		if totalTODO == 0 && totalTODOFulfilled == 0 {
			return "unprocessed"
		}
		if totalTODO == totalTODOFulfilled {
			return "processed"
		}
		return "processing"
	}
	
	
	private func assertGPS() {
		if GPS.length() == 0 {
			GPS = "0,0"
		}
	}
	public var Longitude: Double {
		get {
			assertGPS()
			return Double(GPS.after(","))!
		}
		set {
			GPS = "\(Latitude),\(newValue)"
		}
	}
	public var Latitude: Double {
		get {
			assertGPS()
			return Double(GPS.before(","))!
		}
		set {
			GPS = "\(newValue),\(Longitude)"
		}
	}
	
	public var Key: String {
		get {
			return "ST\(ID!)"
		}
	}

	public static func getIDsForTODOItems(db: SQLDBInstance, id: Int, includeChildren: Bool, includeComplete: Bool) -> String {
		let ds = DelimitedString()
		var sql = "SELECT ID FROM Action WHERE LinkID = ? AND LinkType = 0 AND Required = '1' "
		if !includeComplete {
			sql += " AND IsComplete IS NULL"
		}
		ds.append(db.queryList(sql, hintValue: "", parms: id))
		if includeChildren {
			let idsIn = Street.getChildrenIDs(db: db, id: id).toDelimitedString(delimiter: ",")
			if idsIn.length() > 0 {
				sql = "SELECT ID FROM Action WHERE LinkID IN (\(idsIn)) AND LinkType = 1 WHERE Required = '1'"
				if !includeComplete {
					sql += " AND IsComplete IS NULL"
				}
				ds.append(db.queryList(sql, hintValue: ""))
			}
		}
		return ds.toString(",")
	}

	public func getIDsForTODOItems(includeChildren: Bool, includeComplete: Bool = false) -> String {
		return Street.getIDsForTODOItems(db: SQLDB, id: ID!, includeChildren: includeChildren, includeComplete: includeComplete)
	}
	
	public static func getPropertiesCSV(db: SQLDBInstance, id: Int) -> String {
		let sql = "SELECT ID FROM Property WHERE SID = ?"
		return db.queryList(sql, hintValue: "", parms: id).toDelimitedString(delimiter: ",")
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
	public init(db : SQLDBInstance, data: StreetDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
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
			handler?.dataChanged()
		}
	}

	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Street") {
			let sql = "CREATE TABLE Street (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, PropertyCount INTEGER, ElectorCount INTEGER, GPS TEXT, Meta TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Street")
			SQLDB.assertIndex(indexName: "idxStreetIDs", table: "Street", fields: ["PDID", "SID", "PID", "EID"])
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Street (Name, PropertyCount, ElectorCount, GPS, Meta, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?)"
		_id = SQLDB.execute(sql, parms: Name, PropertyCount, ElectorCount, GPS, MetaData.getSignature(true), _pdid, _sid, _pid, _eid, Date())
		SQLDB.execute("UPDATE Street SET SID = ? WHERE ID = ?", parms: _id, _id)
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Street SET Name = ?, PropertyCount = ?, ElectorCount = ?, GPS = ?, PDID = ?, SID = ?, PID = ?, EID = ?, Meta = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: Name, PropertyCount, ElectorCount, GPS, _pdid, ID ?? _sid, _pid, _eid, MetaData.getSignature(true))
	}
	
	public var Name = "", PropertyCount = 0, ElectorCount = 0, GPS = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any?] {
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
		PropertyCount = Property.count(db: SQLDB, street: ID ?? -1)
		ElectorCount = Elector.count(db: SQLDB, street: ID ?? -1)
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
	
	public func recalculateCounts() {
		if _hasTable {
			PropertyCount = Property.count(db: SQLDB, street: ID!)
			ElectorCount = Elector.count(db: SQLDB, street: ID!)
		}
	}
	
	public static func count(db: SQLDBInstance, pollingDistrict: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Street WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func assertCounts(db: SQLDBInstance) {
		let sql = "UPDATE Street SET PropertyCount = (SELECT COUNT(*) FROM Property WHERE Property.SID = Street.ID)"
		db.execute(sql)

		let sql2 = "UPDATE Street SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.SID = Street.ID)"
		db.execute(sql2)
		
		let sql3 = "UPDATE Property SET ElectorCount = (SELECT COUNT(*) FROM Elector WHERE Elector.PID = Property.ID)"
		db.execute(sql3)
	}
	
	public func createProperty() -> Property {
		let ret = Property(db: SQLDB)
		ret.SID = ID!
		ret.PDID = PDID
		return ret
	}
	
	public func GetProperties() -> [Property] {
		var ret : [Property] = []
		SQLDB.processMultiRow(rowHandler: { (row) in
			ret.append(Property(db: SQLDB, row: row))
		}, "SELECT * FROM Property WHERE SID = ? ORDER BY PID", ID!)
		return ret
	}

	public func GetElectors() -> [Elector] {
		var ret : [Elector] = []		
		SQLDB.processMultiRow(rowHandler: { (row) in
			ret.append(Elector(db: SQLDB, row: row))
		}, "SELECT * FROM Elector WHERE SID = ? ORDER BY PID, EID", ID!)
		return ret
	}

	override public func reassertCounts() {
		ElectorCount = SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE SID = ?", 0, ID!)
		PropertyCount = SQLDB.queryValue("SELECT COUNT(*) FROM Property WHERE SID = ?", 0, ID!)
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

public extension Street {
	static func countIncompleteProperties(db: SQLDBInstance, id: Int) -> Int {
		let sql = "SELECT COUNT(*) FROM Property P INNER JOIN Action A ON P.SID = A.SID WHERE A.SID = ? AND A.IsComplete IS NULL AND A.Required = 1 AND A.RequestedCodes NOT IN ('TODO', '')"
		return db.queryValue(sql, 0, id)
	}
}
