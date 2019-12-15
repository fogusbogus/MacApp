//
//  Splits.swift
//  RegisterDB
//
//  Created by Matt Hogg on 14/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib

public class Splits {
	static let shared = Splits()
	
	private init() {
	}
	
	private var _propSplit = Dictionary<Int, Dictionary<Int, Dictionary<Int, Int>>>()
	private var _elecSplit = Dictionary<Int, Dictionary<Int, Dictionary<Int, Int>>>()

	private func populateSplit(db: SQLDBInstance, split: inout Dictionary<Int, Dictionary<Int, Dictionary<Int, Int>>>, maxCount: Int, sql: String, parentKey: String, id: String) {
		split.removeAll()
		
		db.processMultiRow(rowHandler: { (csr) in
			
			let pID = csr.get(parentKey, -1)
			if !split.keys.contains(pID) {
				split[pID] = Dictionary<Int, Dictionary<Int, Int>>()
			}
			var idx = split[pID]!
			var current = idx.count - 1
			var newSplit = (current < 0) || (maxCount < 1)
			if !newSplit {
				let items = idx[current]!
				if items.count >= maxCount {
					newSplit = true
				}
			}
			if newSplit {
				current += 1
				idx[current] = Dictionary<Int, Int>()
			}
			var idxItems = idx[current]!
			idxItems[idxItems.count] = csr.get("id", -1)
			
		}, sql)
		
	}
	
	public func updateSplits(db: SQLDBInstance) {
		populateSplit(db: db, split: &_propSplit, maxCount: Globals.shared.splitCount, sql: "SELECT * FROM Property ORDER BY SID, sysOrder, ID", parentKey: "SID", id: "ID")
		populateSplit(db: db, split: &_elecSplit, maxCount: Globals.shared.splitCount, sql: "SELECT * FROM Elector ORDER BY PID, sysOrder, ID", parentKey: "PID", id: "ID")
	}
	
	public func assertSplits(db: SQLDBInstance) {
		if _propSplit.count == 0 {
			updateSplits(db: db)
		}
	}
	
	public func streetSplitForProperty(db: SQLDBInstance, propertyID: Int) -> [Int:Int] {
		let idx = streetSplitIndex(db: db, propertyID: propertyID)
		if idx < 0 {
			return [:]
		}
		let stID = db.queryValue("SELECT SID FROM Property WHERE ID = ? LIMIT 1", -1, propertyID)
		if stID < 0 {
			return [:]
		}
		return _propSplit[stID]![idx]!
	}
	
	public func propertySplitForElector(db: SQLDBInstance, electorID: Int) -> [Int:Int] {
		let idx = propertySplitIndex(db: db, electorID: electorID)
		if idx < 0 {
			return [:]
		}
		let prID = db.queryValue("SELECT PID FROM Elector WHERE ID = ? LIMIT 1", -1, electorID)
		if prID < 0 {
			return [:]
		}
		return _elecSplit[prID]![idx]!
	}
	
	public func streetSplitIndex(db: SQLDBInstance, propertyID: Int) -> Int {
		assertSplits(db: db)
		let stID = db.queryValue("SELECT SID FROM Property WHERE ID = ? LIMIT 1", -1, propertyID)
		if stID < 0 {
			return -1
		}
		let st = _propSplit[stID]!
		for stKey in st.keys {
			if st[stKey]!.values.contains(propertyID) {
				return stKey
			}
		}
		return -1
	}
	
	public func propertySplitIndex(db: SQLDBInstance, electorID: Int) -> Int {
		let prID = db.queryValue("SELECT PID FROM Elector WHERE ID = ? LIMIT 1", -1, electorID)
		if prID < 0 {
			return -1
		}
		let pr = _elecSplit[prID]!
		for prKey in pr.keys {
			if pr[prKey]!.values.contains(electorID) {
				return prKey
			}
		}
		return -1
	}
}
