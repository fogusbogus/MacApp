//
//  Migration.swift
//  MacRegisterSupport
//
//  Created by Matt Hogg on 24/05/2023.
//

import Foundation
import LoggingLib

class Log : ConsoleLog {}

public struct MigrationData: Codable {
	public init() {
		pollingDistricts = []
	}
	public var pollingDistricts: [MigrationPollingDistrict]
}

public struct MigrationPollingDistrict: Codable {
	public init() {
		name = ""
		wards = []
	}
	public var name: String
	public var wards: [MigrationWard]
}

public struct MigrationWard: Codable {
	public init() {
		name = ""
		streets = []
	}
	public var name: String
	public var sort: String?
	public var streets: [MigrationStreet]
}

public struct MigrationStreet: Codable {
	public init() {
		name = ""
	}
	public var name: String
	public var sort: String?
	public var postCode: String?
}

public class Migration {
	public static func read(path: String) -> MigrationData? {
		let fm = URL(filePath: path)

		if let json = try? String(contentsOf: fm) {
			let data = Data(json.utf8)
			do {
				return try JSONDecoder().decode(MigrationData.self, from: data)
			}
			catch {
				Log.devMode = true
				Log.error(error)
			}
		}
		return nil
	}
}
