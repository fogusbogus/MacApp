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
import Logging
import MapKit


public class Property : TableBased<Int> {
	
	override public init(db : SQLDBInstance, _ id: Int?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	public init(db : SQLDBInstance, data: PropertyDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
		Data = data
	}
	
	public var Data : PropertyDataStruct {
		get {
			return PropertyDataStruct(Name: Name, NumberPrefix: NumberPrefix, NumberSuffix: NumberSuffix, DisplayName: DisplayName, ElectorCount: ElectorCount, Number: Number, ID: ID, GPS: GPS, Meta: MetaData.getSignature(true), EID: EID.Nil(), PID: PID.Nil(), SID: SID.Nil(), PDID: PDID.Nil(), Split: Split, SplitCount: SplitCount, TodoActions: TodoActions, Status: Status)
		}
		set {
			self.ID = newValue.ID
			self.PDID = newValue.PDID.Nil()
			self.SID = newValue.SID.Nil()
			self.PID = newValue.PID.Nil()
			self.EID = newValue.EID.Nil()
			
			self.Name = newValue.Name
			self.NumberPrefix = newValue.NumberPrefix
			self.NumberSuffix = newValue.NumberSuffix
			self.Number = newValue.Number
			self.ElectorCount = newValue.ElectorCount
			self.MetaData.load(json: newValue.Meta, true)
			self.Split = newValue.Split!
			self.SplitCount = newValue.SplitCount!
			self.TodoActions = newValue.TodoActions
			self.Status = newValue.Status!
			handler?.dataChanged()
		}
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Property") {
			let sql = "CREATE TABLE Property (ID INTEGER PRIMARY KEY AUTOINCREMENT, DisplayName TEXT, Name TEXT, Number INTEGER, NumberPrefix TEXT, NumberSuffix TEXT, ElectorCount INTEGER, GPS TEXT, Meta TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Property")
			SQLDB.assertIndex(indexName: "idxPropertyIDs", table: "Property", fields: ["PDID", "SID", "PID", "EID"])
		}
	}
	
	override func assertExtra() {
		SQLDB.assertColumn(tableName: "Property", nameAndTypes: ["Split":"INTEGER"])
		SQLDB.assertColumn(tableName: "Property", nameAndTypes: ["SplitCount":"INTEGER"])
		SQLDB.assertColumn(tableName: "Property", nameAndTypes: ["TodoActions":"TEXT"])
		SQLDB.assertColumn(tableName: "Property", nameAndTypes: ["Status":"INTEGER"])
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Property (DisplayName, Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, Meta, PDID, SID, PID, EID, Created, Split, SplitCount, TodoActions, Status) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
		_id = SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(true), _pdid, _sid, _pid, _eid, Date(), Split, SplitCount, TodoActions, Status)
		SQLDB.execute("UPDATE Property SET PID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Property SET DisplayName = ?, Name = ?, Number = ?, NumberPrefix = ?, NumberSuffix = ?, ElectorCount = ?, GPS = ?, Meta = ?, PDID = ?, SID = ?, PID = ?, EID = ?, Split = ?, SplitCount = ?, TodoActions = ?, Status = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(true), _pdid, _sid, ID ?? _pid, _eid, Split, SplitCount, TodoActions, Status)
	}
	
	public var DisplayName = "", Name = "", Number = 0, NumberPrefix = "", NumberSuffix = "", ElectorCount = 0, GPS = "", TodoActions = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1, Split = 0, SplitCount = 0, Status = 0
	private var _created = Date()
	
	private func assertGPS() {
		if GPS.length() == 0 {
			GPS = "0,0"
		}
	}
	
	override func signatureItems() -> [Any?] {
		return [Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(), _pdid, _sid, _pid, _eid, _created, Split, SplitCount, TodoActions, Status] + super.signatureItems()
	}
	
	override public func getChildIDs() -> [Int] {
		let sql = "SELECT ID FROM Elector WHERE PID = \(ID ?? -1) ORDER BY ID"
		return SQLDB.queryMultiRow(sql).map { (row) -> Int in
			return row.get("ID", -1)
		}
	}
	
	override public var hasChildren: Bool {
		get {
			return ElectorCount > 0
		}
	}
	
	override public var MetaData: PropertyMeta {
		get {
			_metaData = _metaData ?? PropertyMeta()
			return _metaData as! PropertyMeta
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM Property WHERE ID = \(ID ?? -1)")
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		Name = row.get("Name", "")
		Number = row.get("Number", 0)
		NumberPrefix = row.get("NumberPrefix", "")
		NumberSuffix = row.get("NumberSuffix", "")
		ElectorCount = Elector.count(db: SQLDB, property: ID ?? -1)
		GPS = row.get("GPS", "")
		MetaData.load(json: row.get("Meta", ""), true)

		_pdid = row.get("PDID", -1)
		_sid = row.get("SID", -1)
		_pid = row.get("PID", -1)
		_eid = row.get("EID", -1)
		_created = row.get("Created", Date())
		
		DisplayName = row.get("DisplayName", "")
		
		Split = row.get("Split", 0)
		SplitCount = row.get("SplitCount", 0)
		TodoActions = row.get("TodoActions", "")
		Status = row.get("Status", 0)
	}
	
	public func getDisplayName() -> String {
		let ret = Name.nonBlank("\(NumberPrefix)\(Number)\(NumberSuffix)")
		DisplayName = ret
		return ret
	}
	
	public static func getDisplayNameFromSQLRow(_ row : SQLRow) -> String {
		let np = row.get("NumberPrefix", "")
		let n = row.get("Number", 0)
		let ns = row.get("NumberSuffix", "")
		let ret = row.get("Name", "").nonBlank("\(np)\(n)\(ns)")
		return ret
	}
	


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func count(db: SQLDBInstance, pollingDistrict: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func count(db: SQLDBInstance, street: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Property WHERE SID = \(street)", 0)
	}

	public func createElector() -> Elector {
		let ret = Elector(db: SQLDB)
		ret.PID = ID!
		ret.SID = SID
		ret.PDID = PDID
		return ret
	}
	
	public func recalculateCounts() {
		if _hasTable {
			ElectorCount = Elector.count(db: SQLDB, street: ID!)
		}
	}
	
	override public func reassertCounts() {
		ElectorCount = SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PID = ?", 0, ID!)
	}

	
	public static func propertyExists(db: SQLDBInstance, name: String, numberPrefix: String, number: Int, numberSuffix: String, sid: Int) -> Bool {
		let sql = "SELECT COUNT(*) FROM Street WHERE Name LIKE ? AND NumberPrefix LIKE ? AND Number = ? AND NumberSuffix LIKE ? AND SID = ?"
		return db.queryValue(sql, 0, name, numberPrefix, number, numberSuffix, sid) > 0
	}
	
	public static func propertyExists(db: SQLDBInstance, data: PropertyDataStruct) -> Bool {
		let sql = "SELECT COUNT(*) FROM Street WHERE Name LIKE ? AND NumberPrefix LIKE ? AND Number = ? AND NumberSuffix LIKE ? AND SID = ?"
		return db.queryValue(sql, 0, data.Name, data.NumberPrefix, data.Number, data.NumberSuffix, data.SID.Nil()) > 0
	}
	
	public static func nextAvailableProperty(db: SQLDBInstance, current: PropertyDataStruct) -> PropertyDataStruct {
		if current.SID != nil {
			var current = current.suggestNextProperty()
			while propertyExists(db: db, data: current) {
				current = current.suggestNextProperty()
			}
			return current
		}
		return current.suggestNextProperty()
	}
	
	public static func clearResidents(db: SQLDBInstance, id: Int, action: Action, undo: Bool) {
		if undo {
			undoClearResidents(db: db, id: id, action: action)
			return
		}
		
		//Look to see if there is already a NEWRES against the property
		var sql = "SELECT ID FROM Action WHERE Retract <> 1 AND LinkType = 1 AND LinkID = ? AND Code = 'NEWRES' LIMIT 1"
		let minID = db.queryValue(sql, -1, id)
		
		//Grab a list of the NEWELEC actions
		sql = "SELECT ID FROM Action WHERE ID > ? AND Code = 'NEWELEC' NAD LinkType = 1 AND LinkID = ? AND Retract <> 1 AND IFNULL(INT_ID, '') = ''"
		let ids = db.queryList(sql, hintValue: "", parms: minID, id)
		let newElecs = ",".delimit(ids.map { String($0)})
		action.CodeData = ["cleared":newElecs].jsonString!
		if action.ID ?? -1 < 0 {
			action.oldSaveRecord(asEdit: false)
		}
		
		sql = "UPDATE Action SET SupersedeID = \(action.ID!) WHERE LinkID = \(id) AND LinkType = 1 AND IFNULL(INT_ID, '') = '' AND Code IN ('\(Globals.shared.aliases(code: "NEWELEC"))') AND IFNULL(SupersedeID, 0) < 1"
		db.execute(sql)
		
		let code = ActionCodeCache.shared["NEWRES"]?.MetaData
		let groupIgnore = code?.get("groupignore", "")
		let deletecode = code?.get("deletecode", "")
		var deleteCodes = ActionGroup(db: db, groupIgnore).Codes
		
		if deleteCodes.trim().length() == 0 {
			return
		}
		
		deleteCodes = "'" + deleteCodes.replacingOccurrences(of: "~", with: "','")
		
		sql = "SELECT ID FROM Elector WHERE PropertyID = ?"
		var elecIDs = db.queryList(sql, hintValue: -1, parms: id)
		var validIDs : [Int] = []
		
		for elecID in elecIDs {
			sql = "SELECT COUNT(*) FROM Action WHERE EID = ? AND Code IN (\(deleteCodes)) AND Retract <> 1"
			if db.queryValue(sql, 0, elecID) == 0 {
				//Not already deleted
				validIDs.append(elecID)
			}
		}
		
		elecIDs = []
		elecIDs.append(contentsOf: validIDs)
		
		for elecID in elecIDs {
			let delAction = Action(db: db, -1)
			delAction.Code = deletecode!
			delAction.LinkType = 2
			delAction.LinkID = elecID
			delAction.CodeData = ["clearaction":action.ID!].jsonString!
			delAction.oldSaveRecord(asEdit: false)
		}
	}
	
	public static func undoClearResidents(db: SQLDBInstance, id: Int, action: Action) {
		if action.CodeData.isEmptyOrWhitespace() {
			return
		}
		
		let findJson = ["clearaction":id].jsonString!
		var sql = "DELETE FROM Action WHERE Retract <> '1' AND PID = ? AND Data LIKE ? AND IFNULL(INT_ID, '') = ''"
		db.execute(sql, parms: id, findJson)
		sql = "UPDATE Action SET SupersedeID = NULL WHERE SupersedeID = ? AND IFNULL(INT_ID, '') = ''"
		db.execute(sql, parms: action.ID!)
	}
	
	/*

	*/
}

public struct PropertyDataStruct {
	public init(Name: String, NumberPrefix: String, NumberSuffix: String, DisplayName: String, ElectorCount: Int, Number: Int, ID: Int?, GPS: String, Meta : String, EID: Int?, PID: Int?, SID: Int?, PDID: Int?, Split : Int?, SplitCount : Int?, TodoActions : String, Status : Int?) {
		
		self.Name = Name
		self.NumberPrefix = NumberPrefix
		self.NumberSuffix = NumberSuffix
		self.DisplayName = DisplayName
		self.ElectorCount = ElectorCount
		self.Number = Number
		self.ID = ID
		self.GPS = GPS
		self.Meta = Meta
		self.EID = EID
		self.PID = PID
		self.SID = SID
		self.PDID = PDID
		self.Split = Split
		self.SplitCount = SplitCount
		self.TodoActions = TodoActions
		self.Status = Status
	}
	
	
	public var Name = "", NumberPrefix = "", NumberSuffix = "", DisplayName = "", Meta = ""
	public var ElectorCount = 0, Number = 0
	
	public var ID : Int?
	public var GPS = ""
	public var EID : Int?
	public var PID : Int?
	public var SID : Int?
	public var PDID : Int?
	
	public var Split : Int?, SplitCount : Int?, TodoActions = "", Status : Int?
	
	public func suggestNextProperty() -> PropertyDataStruct {
		var ret = self
		if Number > 0 {
			let letter = NumberSuffix.left(1)
			if letter.length() > 0 {
				let chars = "abcdefghijklnopqrstuvwxyz".after(letter.lowercased())
				if chars.length() == 0 {
					ret.NumberSuffix = "a"
					ret.Number += 1
				}
				else {
					ret.NumberSuffix = chars.left(1)
				}
			}
			else {
				ret.Number += 1
			}
		}
		else {
			ret.Name = ""
			ret.NumberPrefix = ""
			ret.NumberSuffix = ""
			ret.Number = 0
		}
		return ret
	}
	
	public func GetProperties(db: SQLDBInstance) -> [Property] {
		let rows = db.queryMultiRow("SELECT * FROM Property WHERE SID = ? ORDER BY PID", ID!)
		var ret : [Property] = []
		for row in rows {
			ret.append(Property(db: db, row: row))
		}
		return ret
	}
	
	public func GetElectors(db: SQLDBInstance) -> [Elector] {
		let rows = db.queryMultiRow("SELECT * FROM Elector WHERE PID = ? ORDER BY EID", ID!)
		var ret : [Elector] = []
		for row in rows {
			ret.append(Elector(db: db, row: row))
		}
		return ret
	}
}

extension Property : HasTODOItems {

	public static func getIDsForTODOItems(db: SQLDBInstance, id: Int, includeChildren: Bool, includeComplete: Bool) -> String {
		var sql = "SELECT ID FROM Action WHERE LinkID = ? AND LinkType = 1 WHERE Required = '1'"
		if !includeComplete {
			sql += " AND IsComplete IS NULL"
		}
		var ds = db.queryList(sql, hintValue: "", parms: id)
		if includeChildren {
			
			let idsIn = Property.getChildrenIDs(db: db, id: id).toDelimitedString(delimiter: ",")
			if idsIn.length() > 0 {
				
				sql = "SELECT ID FROM Action WHERE LinkID IN (\(idsIn)) AND LinkType = 2 WHERE Required = '1'"
				if !includeComplete {
					sql += " AND IsComplete IS NULL"
				}

				db.processMultiRow(rowHandler: { (csr) in
					ds.append("\(csr.get(0,0)):\(csr.get(1,0))")
				}, sql)
				
			}
		}
		return ds.toDelimitedString(delimiter: ",")
	}
	
	public func getIDsForTODOItems(includeChildren: Bool, includeComplete: Bool = false) -> String {
		
		return Property.getIDsForTODOItems(db: SQLDB, id: ID!, includeChildren: includeChildren, includeComplete: includeComplete)
	}

}

extension Property : KeyedItem {
	public var Key: String {
		get {
			return "PR\(ID!)"
		}
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

	public static func getCalculatedName(db: SQLDBInstance, id: Int) -> String {
		let row = db.querySingleRow("SELECT * FROM Property WHERE ID = ? LIMIT 1", id)
		let np = row.get("NumberPrefix", "")
		let n = row.get("Number", 0)
		let ns = row.get("NumberSuffix", "")
		let ret = row.get("Name", "").nonBlank("\(np)\(n)\(ns)")
		return ret
	}
	
	public static func getChildrenIDs(db: SQLDBInstance, id: Int) -> [Int] {
		let sql = "SELECT ID FROM Elector WHERE PID = ? ORDER BY ID"
		return db.queryList(sql, hintValue: 0, parms: id)
	}
}

extension Property : LocatableItem {
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

	public func getCoord() -> CLLocationCoordinate2D {
		if GPS.length() == 0 {
			return CLLocationCoordinate2D()
		}
		return CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
	}

}

extension Property: Iconised {
	public static func calculateIcon(db: SQLDBInstance, id: Int) -> String {
		var sql = "SELECT COUNT(*) FROM Action WHERE PID = ? OR (LinkType = 1 AND LinkID = ?) AND Required = '1'"
		let totalTODO = db.queryValue(sql, 0, id, id)
		
		sql = "SELECT COUNT(*) FROM Action WHERE PID = ? OR (LinkType = 1 AND LinkID = ?) AND Required = '1' AND Retract <> 1"
		let totalTODOFulfilled = db.queryValue(sql, 0, id, id)
		
		if totalTODO == 0 && totalTODOFulfilled == 0 {
			return "unprocessed"
		}
		if totalTODO == totalTODOFulfilled {
			return "processed"
		}
		return "processing"
	}
}
