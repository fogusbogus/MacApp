//
//  TableBased.swift
//  RegisterDB
//
//  Created by Matt Hogg on 17/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common
import Logging

public class TableBased<IDType> {
	
	public var Log : IIndentLog? = nil
	public var handler : TableBasedDelegate?

	internal var _id : IDType?
	internal var _originalSignature = ""
	
	
	//TODO: SI01 - This needs to cater for nulls
	//We need something as flexible as Json but not necessarily Json because of
	//speed issues.
	func signatureItems() -> [Any?] {
		return []
	}
	
	public func getChildIDs() -> [IDType] {
		return []
	}
	
	final func getSignature() -> String {
		
		var dct = Dictionary<String, Any?>()
		let sig = signatureItems()
		var index = 0
		for item in sig {
			let key = "\(index)"
			if let dt = item as? Date {
				
				dct[key] = dt.toISOString()
			}
			else {
				dct[key] = item
			}
			index += 1
		}
		let ret = getJson(dict: dct)
		if ret.length() > 0 {
			return ret
		}
		return "\t".join(signatureItems())
	}
	
	private func getJson(dict: Dictionary<String, Any?>) -> String {
		do {
			let ret = try JSONSerialization.data(withJSONObject: dict, options: .sortedKeys)
			if let string = String(data: ret, encoding: String.Encoding.utf8) {
				return string
			}
		}
		catch {
			
		}
		return ""
	}
	
	public final func isDirty() -> Bool {
		return getSignature().compare(_originalSignature) != .orderedSame
	}
	
	public init(db : SQLDBInstance, _ id: IDType?, _ log: IIndentLog? = nil) {
		SQLDB = db
		Log = log ?? Globals.shared.Log
		sanityCheck()
		assertExtra()
		if let id = id {
			ID = id
		}
	}
	
	public init(db : SQLDBInstance, _ log: IIndentLog? = nil) {
		SQLDB = db
		Log = log ?? Globals.shared.Log
		sanityCheck()
		assertExtra()
	}
	
	public init(db : SQLDBInstance, row: SQLRow, _ log: IIndentLog? = nil) {
		SQLDB = db
		Log = log ?? Globals.shared.Log
		sanityCheck()
		assertExtra()
		loadData(row: row)
	}
	
	internal var SQLDB : SQLDBInstance
	
	public func SetDatabase(db: SQLDBInstance) {
		SQLDB = db
	}
	
	var _hasTable = false
	
	/// Check your tables exist and create them in here. Override.
	func sanityCheck() {
		_hasTable = false
	}
	
	func assertExtra() {
		
	}
	
	public func reassertCounts() {
		
	}
	
	public func reload() {
		if let id = ID {
			ID = id
		}
	}
	
	public func IDChanged() {
		//override this to catch a data change
		_originalSignature = getSignature()
	}
	
	func requiresLoad(id: IDType?) -> Bool {
		//you can allow or disallow the id to be changed here
		return true
	}
	
	func loadData() {
		//override and load the data in here. Call the superclass.
	}
	
	func loadData(row: SQLRow) {
		if IDType.self == String.self {
			_id = row.get("ID", "") as? IDType
		}
		else {
			_id = row.get("ID", 0) as? IDType
		}
	}
	
	var idChangeHandler : TableBaseIDChange?
	
	private var _hasLoaded : Bool = false
	public var hasLoaded : Bool {
		get {
			return _hasLoaded
		}
	}
	
	public var ID : IDType? {
		get {
			return _id
		}
		set {
			if (requiresLoad(id: newValue)) {
				clear()
				_id = newValue
				loadData()
				IDChanged()
			}
		}
	}
	
	internal var _metaData : DBLib.Meta?
	public var MetaData : DBLib.Meta {
		get {
			_metaData = _metaData ?? DBLib.Meta()
			return _metaData!
		}
	}
	
	public func clear() {
		_hasLoaded = false
	}
	
	func saveAsNew() {
		//requires an override
	}
	func saveAsUpdate() {
		//requires an override
	}
	
	public final func save() {

		
		if validID() {
			if isDirty() {
				saveAsUpdate()
			}
		}
		else {
			saveAsNew()
		}
		_originalSignature = getSignature()
		MetaData.resetSignature()
	}
	
	public var hasChildren : Bool {
		get {
			return false
		}
	}
	
	public func validID() -> Bool {
		if ID is Int {
			let i = ID as? Int ?? -1
			return i >= 0
		}
		if ID == nil {
			return false
		}
		let s = String(describing: ID!)
		return s.length() > 0
	}
	
}


protocol TableBaseIDChange {
	func IDChanged<IDType>(item: TableBased<IDType>)
}


public class TableBaseCollection<TableBased> {
	private var _tables : [TableBased] = []
	
	public subscript(index: Int) -> TableBased? {
		get {
			if index < 0 || index >= _tables.count {
				return nil
			}
			return _tables[index]
		}
		set {
		}
	}
}

public extension Int {
	func Nil() -> Int? {
		if self < 0 {
			return nil
		}
		return self
	}
}

public extension Optional where Wrapped == Int {
	func Nil() -> Int {
		return self ?? -1
	}
}

public protocol TableBasedDelegate {
	func dataChanged()
}
