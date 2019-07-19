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

class TableBased<IDType> {

	internal var _id : IDType?
	internal var _originalSignature = ""
	
	func signatureItems() -> [Any] {
		return []
	}
	
	final func getSignature() -> String {
		return "\t".join(signatureItems())
	}
	
	final func isDirty() -> Bool {
		return getSignature().compare(_originalSignature) != .orderedSame
	}
	
	init(_ id: IDType?) {
		DB.shared.assertDB()
		if let id = id {
			ID = id
		}
	}
	
	init() {
		DB.shared.assertDB()
	}
	
	var _hasTable = false
	
	/// Check your tables exist and create them in here. Override.
	func sanityCheck() {
		_hasTable = false
	}
	
	func IDChanged() {
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
	
	var idChangeHandler : TableBaseIDChange?
	
	private var _hasLoaded : Bool = false
	var hasLoaded : Bool {
		get {
			return _hasLoaded
		}
	}
	
	var ID : IDType? {
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
	
	func clear() {
		_hasLoaded = false
	}
	
	func saveAsNew() {
		//requires an override
	}
	func saveAsUpdate() {
		//requires an override
	}
	
	final func save() {
		if _id != nil {
			if isDirty() {
				saveAsUpdate()
			}
		}
		else {
			saveAsNew()
		}
		_originalSignature = getSignature()
	}
}


protocol TableBaseIDChange {
	func IDChanged<IDType>(item: TableBased<IDType>)
}


class TableBaseCollection<TableBased> {
	private var _tables : [TableBased] = []
	
	subscript(index: Int) -> TableBased? {
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
