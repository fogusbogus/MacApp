//
//  ElectorExtensions.swift
//  RegisterDB
//
//  Created by Matt Hogg on 12/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions
import SQLDB

public extension Elector {
	func canChangeNINO() -> Bool {
		if MetaData.NINO.length() > 0 {
			return false
		}
		let sql = "SELECT RawData FROM Action WHERE LinkType = 2 AND LinkID = ? AND IFNULL(INT_ID, '') <> '' AND Retract <> 1 AND Required <> 1 ORDER BY TS DESC"
		var ret = true
		SQLDB.processMultiRow(rowHandler: { (csr) in
			let jc = JCollection(json: csr.get(0, ""))
			if jc.get("nino", "").length() > 0 {
				ret = false
			}
		}, sql, ID!)
		return ret
	}
	
	func canChangeDOB(amending: Bool) -> Bool {
		if amending {
			return true
		}
		let sql = "SELECT RawData FROM Action WHERE LinkType = 2 AND LinkID = ? AND IFNULL(INT_ID, '') <> '' AND Retract <> 1 AND Required <> 1 ORDER BY TS DESC"
		var ret = true
		SQLDB.processMultiRow(rowHandler: { (csr) in
			let jc = JCollection(json: csr.get(0, ""))
			if jc.get("dob", "").length() > 0 {
				ret = false
			}
		}, sql, ID!)
		return ret
	}
	
	func calculateCodes() -> String {
		let sql = "SELECT DISTINCT Code FROM Action WHERE LinkID = ? AND LinkType = 2 AND Retract <> 1"
		return SQLDB.queryList(sql, hintValue: "", parms: ID!).toDelimitedString(delimiter: "~")
	}
	
	/*
	func consumeActionData() {
		let sql = "SELECT RawData FROM Action WHERE LinkType = 2 AND LinkID = ? AND IFNULL(Relevant, 1) = 1 AND Required <> 1 AND Retract <> 1 AND Code IN ('AMEND', 'ITR', 'QEAMEND', '*AMEND', '*ITR', '*QEAMEND') ORDER BY TS DESC LIMIT 1"
		
	} */
	
	func recordChange(collection: DelimitedString, original: JCollection, current: JCollection, name: String, itemName: String, defaultValue: String) -> Bool {
		
		let v1 = original.get(name,defaultValue).trim()
		let v2 = current.get(name, defaultValue).trim()
		if v1 != v2 {
			collection.append("\(name) changed from '\(v1)' to '\(v2)'")
			return true
		}
		return false
	}
	
	func getDifferences() -> String {
		let ret = DelimitedString()
		
		//Within the Json data, we have a previous value. From this we can determine what has changed.
		//let data = JCollection(json: ElectorMeta)
		return ""
	}
	
	/// Returns a new instance of the elector's street
	func getStreet() -> Street? {
		if SID == nil {
			return nil
		}
		return Street(db: SQLDB, ID!)
	}
	
	/// Returns a new instance of the elector's property
	func getProperty() -> Property? {
		if PID == nil {
			return nil
		}
		return Property(db: SQLDB, ID!)
	}
	
	static func removeUnsyncedAction(db: SQLDBInstance, id: Int, code: String) {
		var actionID = retractUnsyncedAction(db: db, id: id, code: code)
		if actionID < 0 {
			//This might still exist
			let sql = "SELECT ID FROM Action WHERE LinkType = 2 AND LinkID = ? AND Code = ? AND Retract = 1"
			actionID = db.queryValue(sql, -1, id, code)
		}
		if actionID >= 0 {
			db.execute("DELETE FROM Action WHERE ID = ?", parms: actionID)
		}
	}
	
	static func retractUnsyncedAction(db: SQLDBInstance, id: Int, code: String) -> Int {
		//Get the action for the elector (int_id is blank, matching 'code'). If the action is a completing action (isComplete = 1), make sure we affect the parent items, too.
		let sql = "SELECt * FROM Action WHERE LinkType = 2 AND LinkID = ? AND Code = ? AND Retract <> 1 LIMIT 1"
		let data = db.querySingleRow(sql, id, code)
		var ret = -1
		if data.get("id", -1) >= 0 {
			if data.get("isComplete", "0") == "1" {
				//Get the elector record
				let el = Elector(db: db, id)
				db.execute("UPDATE Elector SET TODOCount = TODOCount + 1 WHERE ID = ?", parms: id)
				db.execute("UPDATE Property SET TODOCount = TODOCount + 1 WHERE ID = ?", parms: el.PID)
				db.execute("UPDATE Street SET TODOCount = TODOCount + 1 WHERE ID = ?", parms: el.SID)
			}
			db.execute("UPDATE Action SET Retract = 1 WHERE ID = ?", parms: data.get("id", 0))
			ret = data.get("id", 0)
		}
		return ret
	}
	
	func isAmended() -> Bool {
		return Elector.isAmended(db: SQLDB, id: ID!)
	}
	
	static func isAmended(db: SQLDBInstance, id: Int) -> Bool {
		let sql = "SELECT COUNT(*) FROM Action WHERE Code IN ('AMEND', 'QEAMEND') AND EID = ? AND Retract <> 1"
		return db.queryValue(sql, 0, id) > 0
	}
	
	func isDeleted() -> Bool {
		return Elector.isDeleted(db: SQLDB, id: ID!)
	}
	
	static func isDeleted(db: SQLDBInstance, id: Int) -> Bool {
		let propID = db.queryValue("SELECT PID FROM Elector WHERE ID = ? LIMIT 1", 0, id)
		let electorDeletedCodes = Globals.shared.get("ELECTORDELETEDCODES", "").nonBlank("INELIGIBLE~GONEAWAY~DECEASED")
		let electorPropCodes = Globals.shared.get("ELECTORDELETEDBYPROPCODE", "").nonBlank("EMPTY~BOARDEDUP~FORSALE~VOID~BUSINESS")
		
		let elecActionsIn = electorDeletedCodes.splitToArray("~").sqlStringList()
		let propActionsIn = electorPropCodes.splitToArray("~").sqlStringList()
		if db.queryValue("SELECT COUNT(*) FROM Action WHERE EID = ? AND Code IN (\(elecActionsIn)) AND Retract <> 1", 0, id) > 0 {
			return true
		}
		return db.queryValue("SELECT COUNT(*) FROM Action WHERE PID = ? AND IFNULL(EID, 0) = 0 AND Code IN (\(propActionsIn)) AND Retract <> 1", 0, propID) > 0
	}
	
	func test() {
		
	}
}


public extension ElectorMeta {
	func calculatedName() -> String {
		return "\(Forename) \(MiddleName) \(Surname)".removeMultipleSpaces(true)
	}
}
