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
	
	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("Property") {
			let sql = "CREATE TABLE Property (ID INTEGER PRIMARY KEY AUTOINCREMENT, DisplayName TEXT, Name TEXT, Number INTEGER, NumberPrefix TEXT, NumberSuffix TEXT, ElectorCount INTEGER, GPS TEXT, PDID INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, Created DATE)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Property")
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Property (DisplayName, Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, PDID, SID, PID, EID, Created) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
		SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, _eid, Date())
		_id = SQLDB.queryValue("SELECT last_insert_rowid()", -1)
		SQLDB.execute("UPDATE Property SET PID = \(ID ?? -1) WHERE ID = \(ID ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Property SET DisplayName = ?, Name = ?, Number = ?, NumberPrefix = ?, NumberSuffix = ?, ElectorCount = ?, GPS = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		SQLDB.execute(sql, parms: getDisplayName(), Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, ID ?? _eid)
	}
	
	public var DisplayName = "", Name = "", Number = 0, NumberPrefix = "", NumberSuffix = "", ElectorCount = 0, GPS = ""
	
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any] {
		return [Name, Number, NumberPrefix, NumberSuffix, ElectorCount, GPS, _pdid, _sid, _pid, _eid, _created] + super.signatureItems()
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
	
	public static func nextAvailableProperty(current: Property) -> Property {
		if let sid = current.SID {
			var current = suggestNextProperty(current: current)
			while propertyExists(name: current.Name, numberPrefix: current.NumberPrefix, number: current.Number, numberSuffix: current.NumberSuffix, sid: sid) {
				current = suggestNextProperty(current: current)
			}
			return current
		}
		return suggestNextProperty(current: current)
	}
	
	public static func suggestNextProperty(current: Property) -> Property {
		
		if current.Number > 0 {
			let letter = current.NumberSuffix.substring(from: 0, length: 1)
			if letter.length() > 0 {
				let chars = "abcdefghijklmnopqrstuvwxyz".after(letter.lowercased())
				if chars.length() == 0 {
					current.NumberSuffix = "a"
					current.Number += 1
				}
				else {
					current.NumberSuffix = chars.left(1)
				}
			}
			else {
				current.Number += 1
			}
		}
		else {
			current.Name = ""
			current.NumberPrefix = ""
			current.Number = 0
			current.NumberSuffix = ""
		}
		
		return current
	}
}
