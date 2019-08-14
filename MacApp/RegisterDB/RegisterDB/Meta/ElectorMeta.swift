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


public class ElectorMeta: Meta, MetaEncrypterDelegate {
	public func encrypt(_ value: String) -> String {
		return encrypt(unencrypted: value, password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
	}
	
	public func decrypt(_ value: String) -> String {
		return decrypt(value: value, password: CryptoInternal.shared.Password, salt: CryptoInternal.shared.Salt, iv: CryptoInternal.shared.IV)
	}
	
	public var DOB: Date? {
		get {
			if hasKey(key: "dob") {
				return Date.fromISOString(date: get("dob", "", self))
			}
			return nil
		}
		set {
			if newValue != nil {
				set("dob", newValue?.toISOString(), self)
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
			return get("nino", "", self)
		}
		set {
			setOrRemove("nino", newValue, self)
		}
	}
	
	public var Email: String {
		get {
			return get("email", "", self)
		}
		set {
			setOrRemove("email", newValue, self)
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
	
	public var Nationality: String {
		get {
			return get("nationality", "")
		}
		set {
			setOrRemove("nationality", newValue)
		}
	}
	
	public var PreviousAddress: String {
		get {
			return get("prevaddress", "", self)
		}
		set {
			setOrRemove("prevaddress", newValue, self)
		}
	}
	
	public var PreviousPostCode: String {
		get {
			return get("prevpostcode", "")
		}
		set {
			setOrRemove("prevpostcode", newValue)
		}
	}
	
	public var EvidenceNotes: String {
		get {
			return get("evidencenotes", "")
		}
		set {
			setOrRemove("evidencenotes", newValue)
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
	

	public var AbsentVote: Bool {
		get {
			return "1TtYy".contains(get("av", "").left(1))
		}
		set {
			setOrRemove("av", newValue)
		}
	}
	
	public var OptOut: Bool {
		get {
			return "1TtYy".contains(get("optout", "").left(1))
		}
		set {
			setOrRemove("optout", newValue)
		}
	}
	
	public var Over76: Bool {
		get {
			return "1TtYy".contains(get("over76", "").left(1))
		}
		set {
			setOrRemove("over76", newValue)
		}
	}
	
	public var PostalVote: Bool {
		get {
			return "1TtYy".contains(get("pv", "").left(1))
		}
		set {
			setOrRemove("pv", newValue)
		}
	}
	
	public var SingleOccupier: Bool {
		get {
			return "1TtYy".contains(get("so", "").left(1))
		}
		set {
			setOrRemove("so", newValue)
		}
	}
	


}