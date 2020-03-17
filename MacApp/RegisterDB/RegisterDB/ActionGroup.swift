//
//  ActionGroup.swift
//  RegisterDB
//
//  Created by Matt Hogg on 26/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import LoggingLib

public class ActionGroup : TableBased<String> {
	override public init(db : SQLDBInstance, _ id: String?, _ log: IIndentLog? = nil) {
		super.init(db: db, id, log)
	}
	override public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
	}
	override public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		super.init(db: db, row: row, log)
	}
	public init(db : SQLDBInstance, data: ActionGroupDataStruct, _ log: IIndentLog? = nil) {
		super.init(db: db, log)
		Data = data
	}
	
	public var Data : ActionGroupDataStruct {
		get {
			return ActionGroupDataStruct(Codes: Codes, AppliesTo: AppliesTo, Description: Description, Parent: Parent, ID: ID!, sysOrder: sysOrder)
		}
		set {
			self.ID = newValue.ID
			self.Codes = newValue.Codes
			self.AppliesTo = newValue.AppliesTo
			self.Description = newValue.Description
			self.Parent = newValue.Parent
			self.sysOrder = newValue.sysOrder ?? 0
			handler?.dataChanged()
		}
	}

	override func sanityCheck() {
		super.sanityCheck()
		if !SQLDB.tableExists("ActionGroup") {
			let sql = "CREATE TABLE ActionGroup (ID TEXT PRIMARY KEY, AppliesTo TEXT, Codes TEXT, Desc TEXT, sysOrder INTEGER, Parent TEXT)"
			SQLDB.execute(sql)
			_hasTable = SQLDB.tableExists("ActionGroup")
			SQLDB.assertIndex(indexName: "idxActionGroup_Parent", table: "ActionGroup", fields: ["Parent"])
		}
	}
	
	override func saveAsNew() {
		super.saveAsNew()
		let sql = "INSERT INTO ActionGroup (ID, AppliesTo, Codes, Desc, sysOrder, Parent) " +
		"VALUES (?,?,?,?,?,?)"
		_ = SQLDB.execute(sql, parms: ID, AppliesTo, Codes, Description, sysOrder, Parent)
	}
	
	override func saveAsUpdate() {
		super.saveAsUpdate()
		let sql = "UPDATE ActionGroup SET AppliesTo = ?, Codes = ?, Desc = ?, sysOrder = ?, Parent = ? WHERE ID LIKE ?"
		SQLDB.execute(sql, parms: AppliesTo, Codes, Description, sysOrder, Parent, ID)
	}
	
	public var AppliesTo = "", Codes = "", Description = "", sysOrder = 0, Parent = ""
	
	override func signatureItems() -> [Any?] {
		return [AppliesTo, Codes, Description, sysOrder, Parent] + super.signatureItems()
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override func loadData() {
		let data = SQLDB.querySingleRow("SELECT * FROM ActionGroup WHERE ID LIKE ?", ID)
		loadData(row: data)
	}
	
	override func loadData(row: SQLRow) {
		super.loadData(row: row)
		AppliesTo = row.get("AppliesTo", "")
		Description = row.get("Desc", "")
		Codes = row.get("Codes", "")
		sysOrder = row.get("sysOrder", 0)
		Parent = row.get("Parent", "")
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func getActionCodes() -> [ActionCode] {
		var ret : [ActionCode] = []
		if Codes.length() == 0 {
			return ret
		}
		let codes = Codes.split(separator: "~")
		for code in codes {
			if let ac = ActionCodeCache.shared[code.decomposedStringWithCompatibilityMapping] {
				ret.append(ac)
			}
		}
		return ret
	}

	static func allGroups(db: SQLDBInstance) -> [String:ActionGroup] {
		var ret : [String:ActionGroup] = [:]
		db.processMultiRow(rowHandler: { (row) in
			ret[row.get("ID", "")] = ActionGroup(db: db, row: row)
		}, "SELECT * FROM ActionGroup")
		return ret
	}
	
	static func getAllowedGroups(db: SQLDBInstance, linkType: LinkType, allowedCodes: [String]) -> [ActionGroup] {
		let allGroups : [String:ActionGroup] = [:]
		var groups: [String] = []
		db.processMultiRow(rowHandler: { (csr) in
			let codes = csr.get("codes", "").splitToArray("~")
			//var add = false
			for code in codes {
				if allowedCodes.containsLike(code) {
					let id = csr.get("ID", "")
					groups.append(id)
					var grp = allGroups[id]
					while grp != nil {
						if allGroups.keys.contains(grp!.Parent) {
							if !groups.contains(obj: grp!.Parent) {
								groups.append(grp!.Parent)
							}
							if allGroups.keys.contains(grp!.Parent) {
								grp = allGroups[grp!.Parent]!
							}
							else {
								break
							}
						}
						else {
							break
						}
					}
					//add = true
					break
				}
			}
		}, "SELECT * FROM ActionGroup WHERE AppliesTo = ?", linkType.intValue)
		
		return groups.filter { (s) -> Bool in
			return allGroups.keys.contains(s)
		}.map { (s) -> ActionGroup in
			return allGroups[s]!
		}
	}
	
	static func getAllowedGroups(db: SQLDBInstance, key: String) -> [ActionGroup] {
		let lt = Functions.getLinkTypeAndId(link: key)
		
		return getAllowedGroups(db: db, linkType: lt.linkType, linkID: lt.linkID)
	}
	
	static func getAllowedGroups(db: SQLDBInstance, linkType: LinkType, linkID: Int) -> [ActionGroup] {
		let groups = getAllGroups(db: db, linkType: linkType)
		var ret : [ActionGroup] = []
		for group in groups {
			if group.getAllowedCodes(linkType: linkType, linkID: linkID).count > 0 {
				ret.append(group)
			}
		}
		return ret
	}
	
	func getAllowedCodes(key: String) -> [ActionCode] {
		let lt = Functions.getLinkTypeAndId(link: key)
		return getAllowedCodes(linkType: lt.linkType, linkID: lt.linkID)
	}
	
	func getAllowedCodes(linkType: LinkType, linkID: Int) -> [ActionCode] {
		
		//Get this item's action codes
		let ret : [ActionCode] = getActionCodes()
		
		let ds = ret.map { (ac) -> String in
			return ac.ID!.trim().uppercased()
		}.joined(separator: "~")
		
		let contains = "~\(ds)~"
		
		let allActions : [String] = Action.getAllActionCodesText(db: SQLDB, linkType: linkType, linkID: linkID).splitToArray("~")
		
		var passed : [ActionCode] = []
		
		ret.forEach { (ac) in
			if contains.impliesContains("~\(ac.ID!.trim())~") {
				let pre = ac.Prerequisite
				var canAdd = true
				for strAc in allActions {
					if !pre.isEmptyOrWhitespace() && !ActionCode.Criteria(code: strAc, criteria: pre) {
						canAdd = false
						break
					}
				}
				if canAdd {
					passed.append(ac)
				}
			}
		}
		
		return passed
	}
	
	static func getAllGroups(db: SQLDBInstance, linkType: LinkType) -> [ActionGroup] {
		var ret : [ActionGroup] = []
		
		let sql = "SELECT * FROM ActionGroup WHERE AppliesTo LIKE '%\(linkType.intValue)%' ORDER BY sysOrder"
		
		db.processMultiRow(rowHandler: { (row) in
			ret.append(ActionGroup(db: db, row: row))
		}, sql)
		return ret
	}
	
	static func getBasegroups(db: SQLDBInstance, key: String) -> [ActionGroup] {
		let lt = Functions.getLinkTypeAndId(link: key)
		
		var ret : [ActionGroup] = []
		db.processMultiRow(rowHandler: { (csr) in
			ret.append(ActionGroup(db: db, row: csr))
		}, "SELECT * FROM ActionGroup WHERE IFNULL(Parent, '') = '' AND AppliesTo LIKE '%\(lt.linkType.intValue)%'")
		return ret
	}
	
	func getChildGroups() -> [ActionGroup] {
		var ret : [ActionGroup] = []
		SQLDB.processMultiRow(rowHandler: { (csr) in
			ret.append(ActionGroup(db: SQLDB, row: csr))
		}, "SELECT * FROM ActionGroup WHERE Parent LIKE ?", ID)
		return ret
	}
	
	func getChildGroups(allowedCodes: [ActionCode]) -> [ActionGroup] {
		var ret : [ActionGroup] = []
		
		SQLDB.processMultiRow(rowHandler: { (csr) in
			let codes = csr.get("codes", "").splitToArray("~")
			for code in codes {
				if allowedCodes.first(where: { (ac) -> Bool in
					return ac.ID!.uppercased() == code.uppercased()
				}) != nil {
					ret.append(ActionGroup(db: SQLDB, row: csr))
				}
			}
		}, "SELECT * FROM ActionGroup WHERE Parent LIKE ?", ID)
		return ret
	}
	
	static func FilterCodes(group: ActionGroup?, codes: [ActionCode]) -> [ActionCode] {
		guard group != nil else {
			return codes
		}
		
		var ret : [ActionCode] = []
		let split = group!.Codes.splitToArray("~")
		
		codes.forEach { (ac) in
			if split.containsLike(ac.ID!) {
				ret.append(ac)
			}
		}
		return ret
	}
	
	static func FilterByAppliesTo(db: SQLDBInstance, appliesTo: String) -> [ActionGroup] {
		var ret : [ActionGroup] = []
		
		db.processMultiRow(rowHandler: { (csr) in
			ret.append(ActionGroup(db: db, row: csr))
		}, "SELECT * FROM ActionGroup WHERE AppliesTo LIKE ? ORDER BY sysOrder", appliesTo)
		
		return ret
	}
}

public struct ActionGroupDataStruct {
	var Codes = ""
	var AppliesTo = ""
	var Description = ""
	var Parent = ""

	var ID : String
	var sysOrder : Int?
}
