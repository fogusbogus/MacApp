//
//  ActionCode.swift
//  RegisterDB
//
//  Created by Matt Hogg on 28/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import LoggingLib

public class ActionCode : TableBased<String> {
	override public init(db : SQLDBInstance, _ id: String?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	public init(db : SQLDBInstance, data: ActionCodeDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
		Data = data
	}
	
	public var Data : ActionCodeDataStruct {
		get {
			return ActionCodeDataStruct(Implied: Implied, AppliesTo: AppliesTo, Description: Description, Prerequisite: Prerequisite, Redirect: Redirect, Type: Type, ID: ID!, Alias: Alias, Multiple: Multiple)
		}
		set {
			self.ID = newValue.ID
			self.AppliesTo = newValue.AppliesTo
			self.Description = newValue.Description
			self.Implied = newValue.Implied
			self.Prerequisite = newValue.Prerequisite
			self.Redirect = newValue.Redirect
			self.Alias = newValue.Alias
			self.Multiple = newValue.Multiple
			
			handler?.dataChanged()
		}
	}

	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("ActionCode") {
			let sql = "CREATE TABLE ActionCode (ID TEXT PRIMARY KEY, Description TEXT, AppliesTo TEXT, Implied INTEGER, Prerequisite TEXT, Redirect TEXT, Type TEXT, Alias TEXT, Multiple INTEGER)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("ActionCode")
			//SQLDB.assertIndex(indexName: "idxActionGroup_Parent", table: "ActionGroup", fields: ["Parent"])
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO ActionCode (ID, Description, AppliesTo, Implied, Prerequisite, Redirect, Type, Alias, Multiple) " +
		"VALUES (?,?,?,?,?,?,?,?,?)"
		_ = SQLDB.execute(sql, parms: ID, Description, AppliesTo, Implied ? 1 : 0, Prerequisite, Redirect, Type, Alias, Multiple)
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE ActionCode SET Description = ?, AppliesTo = ?, Implied = ?, Prerequisite = ?, Redirect = ?, Type = ?, Alias = ?, Multiple = ? WHERE ID LIKE ?"
		SQLDB.execute(sql, parms: Description, AppliesTo, Implied ? 1 : 0, Prerequisite, Redirect, Type, Alias, Multiple ? 1 : 0, ID)
	}
	
	public var AppliesTo = "", Description = "", Implied = false, Prerequisite = "", Redirect = "", `Type` = "", Alias = "", Multiple = false
	
	override func signatureItems() -> [Any?] {
		return [Description, AppliesTo, Implied, Prerequisite, Redirect, Type, Alias, Multiple] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM ActionCode WHERE ID LIKE ?", ID)
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		super.loadData(row: row)
		AppliesTo = row.get("AppliesTo", "")
		Description = row.get("Description", "")
		Implied = row.get("Implied", 0) == 1
		Prerequisite = row.get("Prerequisite", "")
		Redirect = row.get("Redirect", "")
		Type = row.get("Type", "")
		Alias = row.get("Alias", "")
		Multiple = row.get("Multiple", 0) == 1
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static func extractParenthesisedText(text: String) -> (extracted: String, leftOver: String) {
		var text = text
		if text.hasPrefix("(") {
			text = text.substring(from: 1)
		}
		
		var opens = 1
		var ret = ""
		while opens > 0 && text.contains(")") {
			opens -= 1
			if ret.length() > 0 {
				ret += ")"
			}
			
			let copy = text.before(")")
			opens += copy.countOccurrenceOf("(")
			ret += copy
			text = text.after(")")
		}
		return (extracted: ret, leftOver: text)
	}
	
	public static func codeAllowed(code: String, criteria: String) -> Bool {
		var code = code.uppercased()
		var criteria = criteria
		if !code.hasPrefix("~") {
			code = "~" + code
		}
		if !code.hasSuffix("~") {
			code += "~"
		}

		var polar = false
		var current = ""
		var and = true, or = false
		var result = true
		
		while criteria.length() > 0 {
			var nextAnd = and, nextOr = or
			var evaluate = false
			let command = criteria.substring(from: 0, length: 1)
			var addChar = true
			
			if command == "!" {
				polar = !polar
				addChar = false
			}
			
			if command == "," {
				nextAnd = true
				nextOr = false
				evaluate = true
				addChar = false
			}
			
			if command == "|" {
				nextAnd = false
				nextOr = true
				evaluate = true
				addChar = false
			}
			
			let subset = command == "("
			if !subset {
				if addChar {
					current += command
				}
				criteria = criteria.substring(from: 1)
				evaluate = evaluate || (criteria.length() == 0)
			}
			else {
				evaluate = true
			}
			if evaluate {
				var isCode = code.contains("~" + current.uppercased() + "~")
				if subset {
					let process = extractParenthesisedText(text: criteria)
					criteria = process.leftOver
					isCode = codeAllowed(code: code, criteria: process.extracted)
				}
				
				if polar {
					isCode = !isCode
				}
				polar = false
				if and {
					result = result && isCode
				}
				if or {
					result = result || isCode
				}
				and = nextAnd
				or = nextOr
				current = ""
			}
		}
		return result
	}
	
	public static func getCodesAllowedList(db: SQLDBInstance, linkType: Int, linkID: Int) -> [ActionCode] {
		let codes = getCodesAllowed(db: db, linkType: linkType, linkID: linkID)
		var ret : [ActionCode] = []
		for c in codes {
			if let ac = ActionCodeCache.shared[c] {
				ret.append(ac)
			}
		}
		return ret
	}

	public static func getCodesAllowed(db: SQLDBInstance, linkType: Int, linkID: Int) -> [String] {
		let discoverCodes = Action.discoverCodes(db: db, linkType: linkType, linkID: linkID)
		return discoverCodes.map { (ac) -> String in
			return ac.ID!
		}
	}
	
	public static func allowMultiple(db: SQLDBInstance, code: String) -> Bool {
		let sql = "SELECT COUNT(*) FROM ActionCode WHERE (ID = ? OR Alias = ?) AND Multiple <> 0"
		return db.queryValue(sql, 0, code, code) > 0
	}
	
	public static func impliedCompleteFor(db: SQLDBInstance, linkID: Int) -> [String] {
		var ret : [String] = []
		
		let sql = "SELECT ID FROM ActionCode WHERE Implied = 1 OR ID = 'COMPLETE' AND AppliesTo LIKE '%~\(linkID)~%'"
		db.processMultiRow(rowHandler: { (row) in
			ret.append(row.get("id", ""))
		}, sql)
		return ret
	}
	
	public static func fromDelimitedString(codes: String) -> [ActionCode] {
		return fromDelimitedString(codes: codes, delimiter: "~")
	}
	
	public static func fromDelimitedString(codes: String, delimiter: String) -> [ActionCode] {
		
		let codeItems = codes.splitToArray(delimiter)
		
		var ret : [ActionCode] = []
		var alreadyCollected = ""
		let acs = ActionCodeCache.shared.allCodes()
		
		for code in codeItems {
			if code.trim().length() > 0 {
				let c = code.trim().uppercased()
				if !alreadyCollected.contains(delimiter + c + delimiter) && acs[c] != nil {
					alreadyCollected += delimiter + c + delimiter
					ret.append(acs[c]!)
				}
			}
		}
		return ret
	}
	
	public static func isImpliedComplete(db: SQLDBInstance, code: String) -> Bool {
		if code.implies("COMPLETE") {
			return true
		}
		
		let sql = "SELECT Implied FROM ActionCode WHERE ID = ? LIMIT 1"
		let ret = db.queryValue(sql, 0, code)
		return ret != 0
	}
	
	public static func discoverCodes(db: SQLDBInstance, linkType: LinkType, linkID: Int) -> [ActionCode] {
		var cds : [String] = []
		
		let sql = "SELECT * FROM Action WHERE Retract <> 1 AND IFNULL(SupersedeID, 0) < 1 AND LinkType = ? AND LinkID = ?"
		db.processMultiRow(rowHandler: { (csr) in
			var code = ""
			if csr.get("Required", "") == "1" {
				code = ":" + csr.get("RequestedCodes", "")
			}
			else {
				code = csr.get("Code", "")
			}
			cds.append(code)
		}, sql, linkType, linkID)
		
		var allCodes : [String] = []
		db.processMultiRow(rowHandler: { (csr) in
			allCodes.append(csr.get("ID", ""))
		}, "SELECT ID FROM ActionCode WHERE AppliesTo LIKE '%\(linkType.intValue)%'")
		allCodes = allCodes.uniqueItems()
		
		let myItems = cds.joined(separator: "~")
		
		var ret : [ActionCode] = []
		for myItem in allCodes {
			let ac = ActionCodeCache.shared[myItem.replacingOccurrences(of: ":", with: "")]
			if ac != nil {
				var bAdd = ac?.Prerequisite.length() == 0
				if !bAdd {
					bAdd = Criteria(code: myItems, criteria: ac!.Prerequisite)
				}
				if bAdd {
					ret.append(ac!)
				}
			}
		}
		return ret
	}
	
	static func Criteria(code: String, criteria: String) -> Bool {
		return false
		
		//TODO:
		//We could put this in the ActionCode itself.
	}
	
	public static func getAllActions(db: SQLDBInstance, linkType: Int, linkID: Int, includeRequired: Bool) -> [Action] {
		var ret : [Action] = []
		
		var sql = "SELECT * FROM Action WHERE LinkType = ? AND LinkID = ? AND Required <> '1' AND Retract <> 1 ORDER BY sysOrder, TS"
		if includeRequired {
			sql = "SELECT * FROM Action WHERE LinkType = ? AND LinkID = ? AND (Required <> '1' OR (Required = '1')) AND Retract <> 1 ORDER BY sysOrder, TS"
		}
		db.processMultiRow(rowHandler: { (csr) in
			ret.append(Action(db: db, row: csr))
		}, sql, linkType, linkID)
		return ret
	}
}

public extension ActionCode {
	var metaRecord: Bool {
		get {
			return MetaData.get("record", true)
		}
	}
	
	var metaVisible: Bool {
		get {
			return MetaData.get("visible", true)
		}
	}
	
	var metaAlternateCode: String {
		get {
			return MetaData.get("alt", ID!)
		}
	}
	
	var metaRecursive: Bool {
		get {
			return MetaData.get("recursive", false)
		}
	}
	
	var metaCanClick: Bool {
		get {
			return MetaData.get("canclick", false)
		}
	}
	
	var metaPopulate: Bool {
		get {
			return MetaData.get("populate", false)
		}
	}
	
	var metaWarnings: [String] {
		get {
			return MetaData.get("warningsfor", "").splitToArray("~")
		}
	}
	
	var metaCapturePreviousAddress: Bool {
		get {
			return MetaData.get("capturepreviousaddress", false)
		}
	}
	
	var metaSaveAs: String {
		get {
			return MetaData.get("saveas", metaActionCode)
		}
	}
	
	var metaEmptyMessage: String {
		get {
			return MetaData.get("emptymessage", "")
		}
	}
	
	var metaActionCode: String {
		get {
			return MetaData.get("actioncode", ID!)
		}
	}

}

public struct ActionCodeDataStruct {
	var Implied = false
	var AppliesTo = ""
	var Description = ""
	var Prerequisite = ""
	var Redirect = ""
	var `Type` = ""

	var ID : String
	var Alias = ""
	var Multiple = false
}

