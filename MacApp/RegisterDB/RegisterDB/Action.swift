//
//  Action.swift
//  RegisterDB
//
//  Created by Matt Hogg on 30/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Logging
import Common


public class Action : TableBased<Int> {
	override public init(db : SQLDBInstance, _ id: Int?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	public init(db : SQLDBInstance, data: ActionDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
		Data = data
	}
	
	public var Data : ActionDataStruct {
		get {
			return ActionDataStruct(ID: ID ?? -1, Code: Code, CodeData : CodeData, Description : Description, InternalID: InternalID, LinkID: LinkID, LinkType: LinkType, Notes: Notes, RequestedCodes: RequestedCodes, Required: Required, Response: Response, Result: Result, sysOrder: 0, Timestamp : Timestamp, StaffName : StaffName, TextDate: TextDate, TextTime: TextTime, Retract  : Retract, SID : SID, PID : PID, EID : EID, RawData: RawData, CurrentStaffID : CurrentStaffID, SupersedeID: SupersedeID, IsComplete : IsComplete)
		}
		set {
			self.ID = newValue.ID
			self.Code = newValue.Code
			self.CodeData = newValue.CodeData
			self.Description = newValue.Description
			self.InternalID = newValue.InternalID
			self.LinkID = newValue.LinkID
			self.LinkType = newValue.LinkType
			self.Notes = newValue.Notes
			self.RequestedCodes = newValue.RequestedCodes
			self.Required = newValue.Required
			self.Response = newValue.Response
			self.Result = newValue.Result
			self.sysOrder = newValue.sysOrder
			self.Timestamp = newValue.Timestamp
			self.StaffName = newValue.StaffName
			self.Retract = newValue.Retract
			self.SID = newValue.SID
			self.PID = newValue.PID
			self.EID = newValue.EID
			self.RawData = newValue.RawData
			self.CurrentStaffID = newValue.CurrentStaffID
			self.SupersedeID = newValue.SupersedeID
			self.IsComplete = newValue.IsComplete

			handler?.dataChanged()
		}
	}

	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("ActionCode") {
			let sql = "CREATE TABLE Action (ID INTEGER PRIMARY KEY, Code TEXT, CodeData TEXT, Description TEXT, INT_ID TEXT, LinkID INTEGER, LinkType INTEGER, Notes TEXT, RequestedCodes TEXT, Required TEXT, Response TEXT, Result TEXT, sysOrder INTEGER, TS TEXT, StaffName TEXT, StaffID INTEGER, TextDate TEXT, TextTime TEXT, Retract INTEGER, SID INTEGER, PID INTEGER, EID INTEGER, IsComplete INTEGER, RawData TEXT, SupersedeID INTEGER)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("Action")
			SQLDB.assertIndex(indexName: "idxAction_StreetID", table: "Action", fields: ["SID"])
			SQLDB.assertIndex(indexName: "idxAction_PropertyID", table: "Action", fields: ["PID"])
			SQLDB.assertIndex(indexName: "idxAction_ElectorID", table: "Action", fields: ["EID"])
			SQLDB.assertIndex(indexName: "idxAction_Code", table: "Action", fields: ["Code"])
			SQLDB.assertIndex(indexName: "idxAction_IsComplete", table: "Action", fields: ["IsComplete"])

		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO Action (ID, Code, CodeData, Description, Int_ID, LinkID, LinkType, Notes, RequestedCodes, Required, Response, Result, sysOrder, TS, StaffName, StaffID, TextDate, TextTime, Retract, SID, PID, EID, IsComplete, RawData, SupersedeID) " +
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
		_ = SQLDB.execute(sql, parms: ID, Code, CodeData, Description, InternalID, LinkID, LinkType, Notes, RequestedCodes, Required, Response, Result, sysOrder, Timestamp.toISOString(), StaffName, CurrentStaffID, TextDate, TextTime, Retract ? 1 : 0, SID, PID, EID, IsComplete ? 1 : 0, RawData)
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE Action SET Code = ?, CodeData = ?, Description = ?, Int_ID = ?, LinkID = ?, LinkType = ?, Notes = ?, RequestedCodes = ?, Required = ?, Response = ?, Result = ?, sysOrder = ?, TS = ?, StaffName = ?, StaffID = ?, TextDate = ?, TextTime = ?, Retract = ?, SID = ?, PID = ?, EID = ?, IsComplete = ?, RawData = ?, SupersedeID = ?  WHERE ID LIKE ?"
		SQLDB.execute(sql, parms: Code, CodeData, Description, InternalID, LinkID, LinkType, Notes, RequestedCodes, Required, Response, Result, sysOrder, Timestamp, StaffName, CurrentStaffID, TextDate, TextTime, Retract ? 1 : 0, SID, PID, EID, IsComplete ? 1 : 0, RawData, SupersedeID, ID)
	}
	
	public var Code = "", Description = "", CodeData = "", InternalID = -1, LinkID = -1, LinkType = -1, Notes = "", RequestedCodes = "", Required = "", Response = "", Result = "", sysOrder = 0, Timestamp = Date(), StaffName = "", CurrentStaffID = -1, Retract = false, SID : Int? = nil, PID : Int? = nil, EID : Int? = nil, IsComplete = false, RawData = "", SupersedeID : Int? = nil
	
	public var TextDate : String {
		get {
			return Timestamp.toString("yyyy-MM-dd")
		}
		set {
		}
	}
	
	public var TextTime : String {
		get {
			return Timestamp.toString("yyyy-MM-dd")
		}
		set {
		}
	}

	override func signatureItems() -> [Any?] {
		return [Code, Description, CodeData, InternalID, LinkID, LinkType, Notes, RequestedCodes, Required, Response, Result, sysOrder, Timestamp, StaffName, CurrentStaffID, Retract, SID ?? -1, PID ?? -1, EID ?? -1, IsComplete, RawData, SupersedeID ?? -1] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM ActionCode WHERE ID LIKE ?", ID)
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		super.loadData(row: row)
		Code = row.get("Code", "")
		CodeData = row.get("CodeData", "")
		Description = row.get("Description", "")
		InternalID = row.get("InternalID", -1)
		LinkID = row.get("LinkID", -1)
		LinkType = row.get("LinkType", -1)
		Notes = row.get("Notes", "")
		RequestedCodes = row.get("RequestedCodes", "")
		Required = row.get("Required", "")
		Response = row.get("Response", "")
		Result = row.get("Result", "")
		sysOrder = row.get("sysOrder", 0)
		Timestamp = Date.fromISOString(date: row.get("TS", ""))
		StaffName = row.get("StaffName", "")
		Retract = row.get("Retract", 0) == 1
		SID = row.get("SID", -1)
		PID = row.get("PID", -1)
		EID = row.get("EID", -1)
		RawData = row.get("RawData", "")
		CurrentStaffID = row.get("CurrentStaffID", -1)
		SupersedeID = row.get("SupersedeID", -1)
		IsComplete = row.get("IsComplete", 0) == 1
		if SID! < 0 {
			SID = nil
		}
		if PID! < 0 {
			PID = nil
		}
		if EID! < 0 {
			EID = nil
		}
		if SupersedeID! < 0 {
			SupersedeID = nil
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////}

	public static func count(db: SQLDBInstance) -> Int {
		db.queryValue("SELECT COUNT(*) FROM Action WHERE Retract <> 1 AND IFNULL(Supersede, 0) = 0", 0)
	}
	
	public static func getCompletionTODOID(db: SQLDBInstance, id: Int) -> String {
		let compSQL = "SELECT INT_ID FROM Action WHERE Required = '1' AND IsComplete = ? ORDER BY ID"
		var ret : [String] = []
		db.processMultiRow(rowHandler: { (row) in
			ret.append(row.get("INT_ID", ""))
		}, compSQL, id)
		return ret.joined(separator: ",")
	}
	
	public static func getJsonForUnsynced(db: SQLDBInstance) -> String {
		let sql = "SELECT * FROM Action WHERE IFNULL(INT_ID, '') = '' AND Retract <> 1 AND IFNULL(SupersedeID, 0) < 1 ORDER BY ID"
		return db.queryRowsAsJson(sql)
	}
	
	public static func getJsonFromSQL(db: SQLDBInstance, sql: String) -> String {
		Globals.shared.DB = db
		var allowedChars = Globals.shared["ALLOWEDCHARS"]
		if allowedChars.length() == 0 {
			allowedChars = "1234567890_QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm"
		}
		
		var rows : [[String:Any]] = []
		
		db.processMultiRow(rowHandler: { (row) in
			var dct : [String:Any] = [:]
			dct["id"] = row.get("id", -1)
			dct["code"] = row.get("code", "")
			dct["ts"] = row.get("ts", Date()).toISOString()
			dct["linkID"] = row.get("linkID", -1)
			dct["linkType"] = row.get("linkType", -1)
			dct["notes"] = row.get("notes", "")
			dct["result"] = row.get("result", "")
			dct["data"] = row.get("data", "")
			var completes : [String] = []
			db.processMultiRow(rowHandler: { (csr) in
				completes.append(csr.get("Int_ID", ""))
			}, "SELECT INT_ID FROM Action WHERE IsComplete = ?", row.get("id", -1))
			dct["completes"] = completes
			let staffID = row.get("staffid", "")
			if staffID.length() > 0 {
				dct["staffid"] = staffID
			}
			rows.append(dct)
		}, sql)
		return getJson(array: rows)
	}
	
	private static func getJson(array: [[String:Any]]) -> String {
		do {
			let ret = try JSONSerialization.data(withJSONObject: array, options: .sortedKeys)
			if let string = String(data: ret, encoding: String.Encoding.utf8) {
				return string
			}
		}
		catch {
			
		}
		return ""
	}
	
	public static func getStreetTodoActions(db: SQLDBInstance) {
		getTodoActions(db: db, table: "Street", groupBy: "SID")
	}
	
	public static func getPropertyTodoActions(db: SQLDBInstance) {
		getTodoActions(db: db, table: "Property", groupBy: "PID")
	}
	
	public static func getElectorTodoActions(db: SQLDBInstance) {
		getTodoActions(db: db, table: "Elector", groupBy: "EID")
	}
	
	private static func getTodoActions(db: SQLDBInstance, table: String, groupBy: String) {
		db.execute("UPDATE [\(table)] SET TodoActions = '', Status = 0")
		var sql = "SELECT \(groupBy), RequestedCodes, COUNT(*) FROM Action WHERE Required = 1 AND IsComplete IS NULL GROUP BY \(groupBy), RequestedCodes ORDER BY \(groupBy)"
		
		var todos : [Int:String] = [:]
		var pid = -1
		var cds : [String] = []
		db.processMultiRow(rowHandler: { (csr) in
			
			let csrPid = csr.get(0, 0)
			if csrPid != pid {
				if pid >= 0 {
					todos[pid] = cds.toDelimitedString(delimiter: "\n")
				}
				pid = csrPid
				cds = []
			}
			let code = csr.get(1, "")
			let count = csr.get(2, 0)
			if count < 2 {
				cds.append(code)
			}
			else {
				cds.append("\(count)x \(code)")
			}
		}, sql)
		if pid >= 0 && cds.count > 0 {
			todos[pid] = cds.toDelimitedString(delimiter: "\n")
		}
		
		sql = "UPDATE [\(table)] SET Status = ?, TodoActions = ? WHERE ID = ?"
		
		let updateData = BulkData()
		todos.forEach { (key: Int, codes: String) in
			var status = 0
			
			if codes.impliesContains("HEF") {
				status += 1
			}
			if codes.impliesContains("ITR") {
				status += 2
			}
			if codes.impliesContains("QEAMEND") {
				status += 4
			}
			updateData.add(status, codes, key)
			updateData.pushRow()
		}
		db.bulkTransaction(sql, updateData)
	}
	
	public static func updateTodoRelated(db: SQLDBInstance, linkType: Int, linkID: Int) {
		var linkType = linkType
		var linkID = linkID
		while linkType >= 0 {
			switch linkType {
			case 2:
				updateTodoActions(db: db, table: "Elector", groupBy: "EID", id: linkID)
				linkID = db.queryValue("SELECT PID FROM Elector WHERE ID = ?", -1, linkID)
				break
				
			case 1:
				updateTodoActions(db: db, table: "Property", groupBy: "PID", id: linkID)
				linkID = db.queryValue("SELECT SID FROM Property WHERE ID = ?", -1, linkID)
				break
				
			case 0:
				updateTodoActions(db: db, table: "Street", groupBy: "SID", id: linkID)
				linkID = -1
				
			default:
				break
				
			}
			linkType -= 1
		}
	}
	
	public static func updateTodoActions(db: SQLDBInstance, table: String, groupBy: String, id: Int) {
		db.execute("UPDATE [\(table)] SET TodoActions = '', Status = 0 WHERE ID = ?", parms: id)
		let sql = "SELECT RequestedCodes, COUNT(*) FROM Action WHERE Required = 1 AND IsComplete IS NULL WHERE \(groupBy) = \(id) GROUP BY RequestedCodes"
		
		var status = 0
		var cds : [String] = []
		db.processMultiRow(rowHandler: { (csr) in
			let code = csr.get(0, "").uppercased()
			let count = csr.get(1, 0)
			if code.implies("HEF") {
				status += 1
			}
			if code.implies("ITR") {
				status += 2
			}
			if count < 2 {
				cds.append(code)
			}
			else {
				cds.append("\(count)x \(code)")
			}
		}, sql)
		if cds.count > 0 {
			db.execute("UPDATE [\(table)] SET TodoActions = ?, Status = ? WHERE \(groupBy) = ?", parms: cds.toDelimitedString(delimiter: "\n"), status, id)
		}
	}
	
	
	//Save the record (non-edit)
	@discardableResult
	func oldSaveRecord() -> Int {
		return saveRecord(asEdit: Retract)
	}
	@discardableResult
	func saveRecord() -> Int {
		return oldSaveRecord()
	}
	@discardableResult
	func saveRecord(asEdit: Bool) -> Int {
		let ret = oldSaveRecord(asEdit: asEdit)
		if Code.implies("NEWRES") {
			Property.clearResidents(db: SQLDB, id: LinkID, action: self, undo: Retract)
		}
		return ret
	}
	@discardableResult
	func oldSaveRecord(asEdit: Bool) -> Int {
		let ac = ActionCodeCache.shared[Code]
		if ac != nil {
			if !(ac?.metaRecord)! {
				return ID!
			}
		}
		
		if InternalID >= 0 {
			return ID ?? InternalID
		}
		
		Globals.shared.refreshSyncStatus()
		
		if (ID ?? -1) >= 0 {
			SQLDB.execute("UPDATE Action SET IsComplete = NULL WHERE IsComplete = ?", parms: ID!)
		}
		
		let completeIDs = DelimitedString(relatedTODO())
		
		completesActionRecords(code: Code, ids: completeIDs)
		
		return -1
	}
	
	public func relatedTODO() -> [String] {
		var ret : [String] = []
		
		if Retract || SupersedeID! > 0 {
			return ret
		}
		
		let compSQL = "SELECT ID FROM Action WHERE LinkID = ? AND LinkType = ? AND Required = '1' AND IsComplete IS NULL AND ('~' || RequestedCodes || '~') LIKE '~\(Code.sqlSafe())~'"
		let ids = SQLDB.queryList(compSQL, hintValue: "", parms: LinkID, LinkType)
		ret.append(contentsOf: ids.map {String($0)})
		return ret
	}
	
	@discardableResult
	private func completesActionRecords(code: String, ids: DelimitedString?) -> Bool {
		var recursive = false
		let ac = ActionCodeCache.shared[code]
		if ac != nil {
			recursive = ac!.metaRecursive
		}
		
		var ret = false
		
		var sql = "SELECT ID FROM Action WHERE IsComplete IS NULL AND Required = 1 AND LinkID = \(LinkID) AND LinkType = \(LinkType)"
		if recursive {
			sql = "SELECT ID FROM Action WHERE IsComplete IS NULL AND Required = 1 AND " + LinkType.switch("", [0:"SID", 1:"PID", 2:"EID"]) + " = \(LinkID)"
		}
		
		if ActionCodeCache.shared[code]!.Implied {
			sql += " AND RequestedCodes = '\(code)'"
		}
		let sqlIDs = SQLDB.queryList(sql, hintValue: "")
		if sqlIDs.count > 0 {
			ret = true
		}
		ids?.appendArray(sqlIDs, unique: true)
		
		let codes = SQLDB.queryList("SELECT ID FROM ActionCode WHERE Alias = ?", hintValue: "", parms: code)
		for actionCode in codes {
			if completesActionRecords(code: actionCode, ids: ids) {
				ret = true
			}
		}
		return ret
	}
	
	public static func discoverCodes(db: SQLDBInstance, linkType: Int, linkID: Int, log: IIndentLog? = nil) -> [ActionCode] {
		var sql = "SELECT * FROM Action WHERE Retract <> 1 AND IFNULL(SupersedeID, 0) < 1 AND LinkType = ? AND LinkID = ?"
		let cds = DelimitedString()
		
		log.SQL(sql)
	
		
		db.processMultiRow(rowHandler: { (csr) in
			var code = ""
			if csr.get("Required", "") == "1" {
				code = ":" + csr.get("RequestedCodes", "")
			}
			else {
				code = csr.get("Code", "")
			}
			cds.appendUnique(code)
		}, sql, linkType, linkID)
		
		let allCodes = DelimitedString()
		sql = "SELECT DISTINCT ID FROM ActionCode WHERE AppliesTo LIKE '%\(linkType)%'"
		allCodes.appendUnique(db.queryList(sql, hintValue: ""))
		
		sql = "SELECT Codes FROM ActionGroup WHERE AppliesTo = ?"
		db.processMultiRow(rowHandler: { (csr) in
			allCodes.appendUnique(csr.get(0, "").splitToArray("~"))
		}, sql, linkType)
		
		//Now go through the prerequisites
		let myItems = cds.toString("~")
		var ret : [ActionCode] = []
		let all = allCodes.items
		for myItem in all {
			let ac = ActionCodeCache.shared.lookup(myItem.replacingOccurrences(of: ":", with: ""))
			if ac != nil {
				var add = ac!.Prerequisite.isEmptyOrWhitespace()
				if !add {
					add = ActionCode.Criteria(code: myItems, criteria: ac!.Prerequisite)
				}
				if add {
					ret.append(ac!)
				}
			}
		}
		return ret
	}
}

public struct ActionDataStruct {
	var ID  = -1, Code = "", CodeData = "", Description = "", InternalID = -1, LinkID = -1, LinkType = -1, Notes = "", RequestedCodes = "", Required = "", Response = "", Result = "", sysOrder = 0, Timestamp = Date(), StaffName = "", TextDate = "", TextTime = "", Retract = false, SID : Int? = nil, PID : Int? = nil, EID : Int? = nil, RawData = "", CurrentStaffID = -1, SupersedeID: Int? = nil, IsComplete = false
}

