//
//  Databases.swift
//  Canvasser
//
//  Created by Matt Hogg on 01/02/2021.
//

import Foundation
import SQLDB

internal class Databases {
	
	static let shared = Databases()
	
	
	// Initialization
	
	private init() {
	}
	
	private var _names : SQLDBInstance? = nil
	private var _reg : SQLDBInstance? = nil
	
	public var Names : SQLDBInstance {
		get {
			if _names == nil {
				_names = SQLDBInstance()
				_names?.open(path: "names.sqlite", openCurrent: true)
			}
			return _names!
		}
	}
	
	public var Register : SQLDBInstance {
		get {
			if _reg == nil {
				_reg = SQLDBInstance()
				
//				let fm = FileManager.default
//				let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				let sqlPath = "file:///Users/matt/Temp/registerDB.sqlite"
				_reg?.open(path: sqlPath)
			}
			return _reg!
		}
	}
	
}
