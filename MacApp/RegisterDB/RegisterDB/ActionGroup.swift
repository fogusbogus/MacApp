//
//  ActionGroup.swift
//  RegisterDB
//
//  Created by Matt Hogg on 26/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

import Foundation
import DBLib
import Common
import Logging

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
	
	override func signatureItems() -> [Any] {
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
	

}

public struct ActionGroupDataStruct {
	var Codes = ""
	var AppliesTo = ""
	var Description = ""
	var Parent = ""

	var ID : String
	var sysOrder : Int?
}
