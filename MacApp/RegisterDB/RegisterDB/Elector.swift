//
//  Elector.swift
//  RegisterDB
//
//  Created by Matt Hogg on 19/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import LoggingLib

//Although we are handling the protocols in extensions below, we can define the class with them. This will add readability.
public class Elector : TableBased<Int> { //}, HasTODOItems, KeyedItem {
	
	override public init(db : SQLDBInstance, _ id: Int?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	public init(db : SQLDBInstance, data: ElectorDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
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
		_id = SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, MetaData.getSignature(true), Markers, _pdid, _sid, _pid, _eid, Date())
		SQLDB.execute("UPDATE Elector SET EID = \(_id ?? -1) WHERE ID = \(_id ?? -1)")
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Elector SET DisplayName = ?, Surname = ?, Forename = ?, MiddleName = ?, Meta = ?, Markers = ?, PDID = ?, SID = ?, PID = ?, EID = ? WHERE ID = \(ID ?? -1)"
		GetPreviousData()
		SQLDB.execute(sql, parms: DisplayName, Surname, Forename, MiddleName, MetaData.getSignature(true), Markers, _pdid, _sid, _pid, ID ?? _eid)
	}
	
	private func GetPreviousData() {
		/*
		TODO:
		We need to see the differences between the original data and the new. We will need to create a previous entry in the json with the original data (note, not the original meta), but only for the data that has changed. If we record everything the string could get huge very quickly.
		*/
	}
	
	public var DisplayName = "", Surname = "", Forename = "", MiddleName = "", Markers = "", OriginalMeta = ""
	private var _pdid = -1, _sid = -1, _pid = -1, _eid = -1
	private var _created = Date()
	
	override func signatureItems() -> [Any?] {
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
	
	public static func getMiddleInitials(middleName: String) -> String {
		let parts = middleName.components(separatedBy: .whitespacesAndNewlines)
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
		OriginalMeta = row.get("Meta", "")
		MetaData.load(json: OriginalMeta, true)

		PDID = row.getNull("PDID", -1)
		SID = row.getNull("SID", -1)
		PID = row.getNull("PID", -1)
		EID = row.getNull("EID", -1)
		_created = row.get("Created", Date())
	}
	
	
	override public var MetaData: ElectorMeta {
		get {
			_metaData = _metaData ?? ElectorMeta()
			return _metaData as! ElectorMeta
		}
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func count(db: SQLDBInstance, pollingDistrict: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Elector WHERE PDID = \(pollingDistrict)", 0)
	}
	
	public static func count(db: SQLDBInstance, street: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Elector WHERE SID = \(street)", 0)
	}
	
	public static func count(db: SQLDBInstance, property: Int) -> Int {
		return db.queryValue("SELECT COUNT(*) FROM Elector WHERE PID = \(property)", 0)
	}
	
	public static func getParentageDisplayInformation(db: SQLDBInstance, id: Int) -> [String:String] {
		let row = db.querySingleRow("SELECT EL.DisplayName AS ELName, PR.DisplayName AS PRName, ST.Name AS STName, PD.Name AS PDName FROM Elector EL LEFT JOIN Property PR ON EL.PID = PR.ID LEFT JOIN Street ST ON EL.SID = ST.ID LEFT JOIN PollingDistrict PD ON EL.PDID = PD.ID WHERE EL.ID = ?", id)
		
		var ret : [String:String] = [:]
		ret["el"] = row.get("ELName", "")
		ret["pr"] = row.get("PRName", "")
		ret["st"] = row.get("STName", "")
		ret["pd"] = row.get("PDName", "")
		return ret
	}
	
	public func recalculateName(electorID: Int? = nil) {
		let sql = "SELECT AC.Data, EL.ID FROM Elector EL INNER JOIN Action AC ON (AC.LinkType = 2 AND AC.LinkID = EL.ID) WHERE EL.ID = ? AND AC.Retract <> 1 AND AC.Code IN ('AMEND', 'NEWELEC', 'ITR', 'QEAMEND') ORDER BY AC.TS DESC"
		
		let newNameData = SQLDB.queryValue(sql, "§", electorID ?? ID)
		
		if newNameData == "§" {
			SQLDB.execute("UPDATE Elector SET DisplayName = Name WHERE ID = ?", parms: electorID ?? ID)
			return
		}
		
		let _fn = Fields.forename.jsonMap
		let _mn = Fields.middle.jsonMap
		let _sn = Fields.surname.jsonMap
		
		let fn = _metaData?[_fn] ?? ""
		let mn = _metaData?[_mn] ?? ""
		let sn = _metaData?[_sn] ?? ""
		let name = "\(fn) \(mn) \(sn)".removeMultipleSpaces(true)
		if name.length() == 0 {
			SQLDB.execute("UPDATE Elector SET DisplayName = Name WHERE ID = ?", parms: electorID ?? ID)
		}
		else {
			SQLDB.execute("UPDATE Elector SET DisplayName = ? WHERE ID = ?", parms: name, electorID ?? ID)
		}
	}
	
	public static func CalculateElectorNames(db: SQLDBInstance) {
		db.assertColumn(tableName: "Elector", nameAndTypes: ["DisplayName":"TEXT"])
		
		//Go through any name defining actions and set the name from that
		var sql = "SELECT EL.ID AS ID, AC.Data AS Data FROM Elector EL INNER JOIN Action AC ON (AC.LinkType = 2 AND AC.LinkID = EL.ID) WHERE AC.Retract <> 1 AND AC.Code IN ('AMEND', 'NEWELEC', 'ITR', 'QEAMEND') ORDER BY AC.TS DESC"
		
		let _fn = Elector.Fields.forename.jsonMap
		let _mn = Elector.Fields.middle.jsonMap
		let _sn = Elector.Fields.surname.jsonMap
		
		var hash : [Int] = []
		let data = BulkData()
		
		db.processMultiRow(rowHandler: { (csr) in
			
			let id = csr.get("id", -1)
			
			//There might be multiple name changing actions per elector. However, we only want the latest one
			if id >= 0 && !hash.contains(id) {
				let json = Meta(json: csr.get("Data", ""))
				let fn = json.get(_fn, "")
				let mn = json.get(_mn, "")
				let sn = json.get(_sn, "")
				
				let name = "\(fn) \(mn) \(sn)".removeMultipleSpaces(true)
				hash.append(id)
				data.add(name, id)
				data.pushRow()
			}
		}, sql)
		
		sql = "UPDATE Elector SET DisplayName = ? WHERE ID = ?"
		
		db.bulkTransaction(sql, data)
		
		//Finally, make sure we have a value in the display name
		db.execute("UPDATE Elector SET DisplayName = Name WHERE IFNULL(DisplayName, '') = ''")
	}
	
	public static func UpdateElectorMetaFromActionMeta(db: SQLDBInstance) {
		var sql = "SELECT LinkID, Result FROM Action WHERE LinkType = 2 AND Retract <> 1 AND Code IN ('AMEND', 'NEWELEC', 'ITR', 'QEAMEND') ORDER BY TS DESC"
		var hash : [Int:String] = [:]
		
		db.processMultiRow(rowHandler: { (csr) in
			let linkID = csr.get("LinkID", -1)
			if !hash.keys.contains(linkID) && linkID >= 0 {
				hash[linkID] = csr.get("Result", "")
			}
		}, sql)
		
		sql = "UPDATE Elector SET Data = ? WHERE ID = ?"
		
		let updateData = BulkData()
		hash.forEach { (key: Int, value: String) in
			updateData.add(value, key)
			updateData.pushRow()
		}
		db.bulkTransaction(sql, updateData)
	}
	
	public enum Fields {
		case title
		case forename
		case middle
		case surname
		case dob
		case nino
		case email
		case phone
		case nationality
		case absentVote
		case optOut
		case type
		case evidence
		case notes
		case previousAddress
		case previousPostCode
		case over76
		case postalVote
		case singleOccupier
		case evidenceNotes
		
		var jsonMap : String {
			get {
				switch self {
				case .title:
					return "title"
				case .forename:
					return "fn"
				case .middle:
					return "mn"
				case .surname:
					return "sn"
				case .dob:
					return "dob"
				case .nino:
					return "nino"
				case .email:
					return "email"
				case .phone:
					return "phone"
				case .nationality:
					return "nat"
				case .absentVote:
					return "av"
				case .optOut:
					return "oo"
				case .type:
					return "type"
				case .evidence:
					return "ev"
				case .notes:
					return "notes"
				case .previousAddress:
					return "prevadd"
				case .previousPostCode:
					return "prevPC"
				case .over76:
					return "o76"
				case .postalVote:
					return "pv"
				case .singleOccupier:
					return "so"
				case .evidenceNotes:
					return "evnotes"
				default:
					return ""
				}
			}
		}
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
	
	public func getDisplayInformation(db: SQLDBInstance) -> [String:String] {
		if let elid = ID {
			return Elector.getParentageDisplayInformation(db: db, id: elid)
		}
		return [:]
	}
}



//Instead of incorporating the protocol into the main code, we can use an extension to seperate it out. It's a little less readable, but actually keeps the code cleaner in practice. It also has the added benefit of encapsulating the functionality of the protocol.

//Another important thing to note is that this doesn't work with vars.

extension Elector : ProvidesJsonData {
	func JSONData() -> String {
		var r : [Elector.Fields:String] = [:]
		
		r[.title] = ""
		

		r[.forename] = Forename
		r[.middle] = MiddleName
		r[.surname] = Surname
		r[.nationality] = MetaData.Nationality.joined(separator: ";")
		r[.dob] = MetaData.DOB?.toISOString()
		r[.nino] = MetaData.NINO
		r[.evidence] = MetaData.Evidence
		r[.evidenceNotes] = MetaData.EvidenceNotes
		r[.notes] = MetaData.Notes
		r[.email] = MetaData.Email
		r[.phone] = MetaData.Phone
		r[.previousAddress] = MetaData.PreviousAddress
		r[.previousPostCode] = MetaData.PreviousPostCode
		r[.over76] = MetaData.Over76 ? "1" : "0"
		r[.postalVote] = MetaData.PostalVote ? "1" : "0"
		r[.singleOccupier] = MetaData.SingleOccupier ? "1" : "0"
		r[.absentVote] = MetaData.AbsentVote ? "1" : "0"

		var o : [String:String] = [:]
		r.forEach { (k, v) in
			o[k.jsonMap] = v
		}
		return o.toJsonString()
	}
	
	
}

extension Elector : HasTODOItems {
	public static func getIDsForTODOItems(db: SQLDBInstance, id: Int, includeChildren: Bool, includeComplete: Bool) -> String {
		var sql = "SELECT ID FROM Action WHERE LinkID = ? AND LinkType = 2 AND Required = '1'"
		if !includeComplete {
			sql += " AND IsComplete IS NULL"
		}
		
		return db.queryList(sql, hintValue: 0, parms: id).toDelimitedString(delimiter: ",")
	}

	public func getIDsForTODOItems(includeChildren: Bool, includeComplete: Bool = false) -> String {
		return Elector.getIDsForTODOItems(db: SQLDB, id: ID!, includeChildren: includeChildren, includeComplete: includeComplete)
	}

}

extension Elector: KeyedItem {
	public var Key: String {
		get {
			return "EL\(ID!)"
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

	
	public static func getChildrenIDs(db: SQLDBInstance, id: Int) -> [Int] {
		return []
	}

	public static func getCalculatedName(db: SQLDBInstance, id: Int) -> String {
		let data = db.querySingleRow("SELECT * FROM Elector WHERE ID = ? LIMIT 1", id)
		let fn = data.get("forename", "")
		let mn = getMiddleInitials(middleName: data.get("middlename", ""))
		let sn = data.get("surname", "")
		return "\(fn) \(mn) \(sn)".removeMultipleSpaces(true)
	}

	
}
