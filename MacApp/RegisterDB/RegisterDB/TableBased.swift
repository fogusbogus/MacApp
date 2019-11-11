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
	
	func signatureItems() -> [Any] {
		return []
	}
	
	public func getChildIDs() -> [IDType] {
		return []
	}
	
	final func getSignature() -> String {
		return "\t".join(signatureItems())
	}
	
	public final func isDirty() -> Bool {
		return getSignature().compare(_originalSignature) != .orderedSame
	}
	
	public init(_ id: IDType?, _ log: IIndentLog? = nil) {
		Log = log
		DB.shared.assertDB()
		sanityCheck()
		if let id = id {
			ID = id
		}
	}
	
	public init(_ log: IIndentLog? = nil) {
		Log = log
		DB.shared.assertDB()
		sanityCheck()
	}
	
	public init(row: SQLRow, _ log: IIndentLog? = nil) {
		Log = log
		DB.shared.assertDB()
		sanityCheck()
		loadData(row: row)
	}
	
	var _hasTable = false
	
	/// Check your tables exist and create them in here. Override.
	func sanityCheck() {
		_hasTable = false
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
		Log.Debug("")
		
		Log.Checkpoint("Test", {
			print("This is called!!")
		}, keyAndValues: [:])
		
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
