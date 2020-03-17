//
//  Databases.swift
//  MacApp
//
//  Created by Matt Hogg on 16/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
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
				_reg?.open(path: "registerDB.sqlite")
			}
			return _reg!
		}
	}

}
