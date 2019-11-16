//
//  DB.swift
//  RegisterDB
//
//  Created by Matt Hogg on 18/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common

class DB {
	static let shared = DB()
	
	private init() {
	}
	
	private var _db : Bool = false
	private var _sqldb : SQLDBInstance? = nil
	
	public var SQLDB : SQLDBInstance {
		get {
			_sqldb = _sqldb ?? SQLDBInstance()
			return _sqldb!
		}
	}
	
	public func assertDB() {
		if !_db {
			SQLDB.open(path: "registerDB.sqlite")
			_db = true
		}
	}
}
