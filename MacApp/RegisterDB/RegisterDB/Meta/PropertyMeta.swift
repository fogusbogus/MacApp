//
//  PropertyMeta.swift
//  RegisterDB
//
//  Created by Matt Hogg on 16/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import SQLDB
import UsefulExtensions
import CommonCrypto

public class PropertyMeta: Meta, MetaCryptoDelegate {
	public func encrypt(_ value: String) -> String {
		return encrypt(unencrypted: value, password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
	}
	
	public func decrypt(_ value: String) -> String {
		return decrypt(value: value, password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
	}
	
	public var PostCode: String {
		get {
			return get("postcode", "")
		}
		set {
			setOrRemove("postcode", newValue)
		}
	}
	
	public var ResidenceType: String {
		get {
			return get("residenceType", "", self)
		}
		set {
			setOrRemove("residenceType", newValue, self)
		}
	}
	
	public var Phone: String {
		get {
			return get("phone", "", self)
		}
		set {
			setOrRemove("phone", newValue, self)
		}
	}

	public var Notes: String {
		get {
			return get("notes", "")
		}
		set {
			setOrRemove("notes", newValue)
		}
	}
	
}
