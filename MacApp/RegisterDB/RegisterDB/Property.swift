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

public class Property : TableBased<Int> {
	override public init(_ id: Int?) {
		super.init(id)
	}
	override public init() {
		super.init()
	}
	override public init(row: SQLRow) {
		super.init(row: row)
	}
	public init(data: PropertyDataStruct) {
		super.init()
		Data = data
	}
	
	public var Data : PropertyDataStruct {
		get {
			return PropertyDataStruct(Name: Name, NumberPrefix: NumberPrefix, NumberSuffix: NumberSuffix, DisplayName: DisplayName, ElectorCount: ElectorCount, Number: Number, ID: ID, GPS: GPS, Meta: MetaData.getSignature(true), EID: EID.Nil(), PID: PID.Nil(), SID: SID.Nil(), PDID: PDID.Nil())
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
			handler?.dataChanged()
		}
	}
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Property") {
			let sql = "CREATE TABLE Property (ID INTEGER PRIMARY KEY AUTOINCREMENT, DisplayName TEXT, Name TEXT, Number INTEGER, NumberPrefix TEXT, NumberSuffix TEXT, ElectorCount INTEGER, GPS TEXT, Meta TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Property")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Property (DisplayName, Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, Meta, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(true), _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Property SET PID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Property SET DisplayName = ?, Name = ?, Number = ?, NumberPrefix = ?, NumberSuffix = ?, ElectorCount = ?, GPS = ?, Meta = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(true), _pdid, _sid, ID ?? _pid, _eid)
	}
	
	public var DisplayName = "", Name = "", Number = 0, NumberPrefix = "", NumberSuffix = "", ElectorCount = 0, GPS = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, MetaData.getSignature(), _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
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
		ElectorCount = Elector.count(property: ID ?? -1)
		GPS = row.get("GPS", "")
		MetaData.load(json: row.get("Meta", ""), true)

		_pdid = row.get("PDID", -1)
		_sid = row.get("SID", -1)
		_pid = row.get("PID", -1)
		_eid = row.get("EID", -1)
		_created = row.get("Created", Date())
		
		DisplayName = row.get("DisplayName", "")
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

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func count(pollingDistrict: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func count(street: Int) -> Int {
		return SQLDB.queryValue("SELECT COUNT(*) FROM Property WHERE SID = \(street)", 0)
	}

	public func createElector() -> Elector {
		let ret = Elector()
		ret.PID = ID!
		ret.SID = SID
		ret.PDID = PDID
		return ret
	}
	
	public static func propertyExists(name: String, numberPrefix: String, number: Int, numberSuffix: String, sid: Int) -> Bool {
		let sql = "SELECT COUNT(*) FROM Street WHERE Name LIKE ? AND NumberPrefix LIKE ? AND Number = ? AND NumberSuffix LIKE ? AND SID = ?"
		return SQLDB.queryValue(sql, 0, name, numberPrefix, number, numberSuffix, sid) > 0
	}
	
	public static func propertyExists(data: PropertyDataStruct) -> Bool {
		let sql = "SELECT COUNT(*) FROM Street WHERE Name LIKE ? AND NumberPrefix LIKE ? AND Number = ? AND NumberSuffix LIKE ? AND SID = ?"
		return SQLDB.queryValue(sql, 0, data.Name, data.NumberPrefix, data.Number, data.NumberSuffix, data.SID.Nil()) > 0
	}
	
	public static func nextAvailableProperty(current: PropertyDataStruct) -> PropertyDataStruct {
		if current.SID != nil {
			var current = current.suggestNextProperty()
			while propertyExists(data: current) {
				current = current.suggestNextProperty()
			}
			return current
		}
		return current.suggestNextProperty()
	}
	
}

public struct PropertyDataStruct {
	public init(Name: String, NumberPrefix: String, NumberSuffix: String, DisplayName: String, ElectorCount: Int, Number: Int, ID: Int?, GPS: String, Meta : String, EID: Int?, PID: Int?, SID: Int?, PDID: Int?) {
		
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
	}
	
	
	public var Name = "", NumberPrefix = "", NumberSuffix = "", DisplayName = "", Meta = ""
	public var ElectorCount = 0, Number = 0
	
	public var ID : Int?
	public var GPS = ""
	public var EID : Int?
	public var PID : Int?
	public var SID : Int?
	public var PDID : Int?
	
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
}
