//
//  CryptoInt.swift
//  RegisterDB
//
//  Created by Matt Hogg on 12/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions

internal class CryptoInternal {
	static let shared = CryptoInternal()
	
	private init() {
	}
	
	private var _salt : Data?
	private var _iv : Data?

	public var Salt : Data {
		get {
			_salt = _salt ?? AES256.randomSalt()
			return _salt!
		}
	}
	
	public var IV : Data {
		get {
			_iv = _iv ?? AES256.randomIv()
			return _iv!
		}
	}
	
	public var Password: String {
		get {
			return "registerdb"
		}
	}
}
