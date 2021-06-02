//
//  AddressLocation.swift
//  DataModel
//
//  Created by Matt Hogg on 15/05/2021.
//

import Foundation

class AddressLocation : JsonCoding {
	init() {
		address = ""
		postOrZipCode = ""
		countryCode = "GBR"
		type = "ADDRESS"
		mainContactName = ""
	}
	var address : String, postOrZipCode: String, countryCode: String
	var type : String
	var mainContactName: String
}


class test {
	init() {
		let a = AddressLocation().toJson()
		let _ = AddressLocation.fromJson(a)
	}
}


