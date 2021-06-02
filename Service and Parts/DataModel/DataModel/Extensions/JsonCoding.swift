//
//  JsonCoding.swift
//  DataModel
//
//  Created by Matt Hogg on 15/05/2021.
//

import Foundation

/// We want to import and export this class as some Json
protocol JsonCoding : Codable {
	/// Create the class from some Json string
	/// - Parameter json: The Json describing the object
	static func fromJson(_ json: String) -> JsonCoding
	/// Convert this object to some Json
	func toJson() -> String
}

extension JsonCoding {
	static func fromJson(_ json: String) -> JsonCoding {
		let enc = JSONDecoder()
		let data = json.data(using: .utf8)
		return try! enc.decode(Self.self, from: data!)
	}
	
	func toJson() -> String {
		let enc = JSONEncoder()
		let data = try! enc.encode(self)
		return String(data: data, encoding: .utf8)!
	}
}
