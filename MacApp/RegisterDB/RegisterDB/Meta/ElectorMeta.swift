//
//  ElectorMeta.swift
//  RegisterDB
//
//  Created by Matt Hogg on 11/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import Common
import CommonCrypto

public class ElectorMeta: Meta {
	public var DOB: Date? {
		get {
			if hasKey(key: "dob") {
				return Date.fromISOString(date: get("dob", ""))
			}
			return nil
		}
		set {
			if newValue != nil {
				set("dob", newValue?.toISOString())
			}
			else {
				remove(key: "dob")
			}
		}
	}
	
	public var Title: String {
		get {
			return get("title", "")
		}
		set {
			setOrRemove("title", newValue)
		}
	}
	public var Gender: String {
		get {
			return get("gender", "")
		}
		set {
			setOrRemove("gender", newValue)
		}
	}
	
	public var NINO: String {
		get {
			return decrypt(key: "nino", password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
		}
		set {
			let v = encrypt(unencrypted: newValue, password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
			setOrRemove("nino", v)
		}
	}
}
