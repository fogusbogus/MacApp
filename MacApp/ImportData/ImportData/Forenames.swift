//
//  main.swift
//  ImportData
//
//  Created by Matt Hogg on 16/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions
import SQLDB

public extension Array where Element : Hashable {
	func uniqueItems() -> [Element] {
		return Array(Set(self))
	}
}


class Names {
	
	
	/*
	//_logFileURL = dir.appendingPathComponent("temp")
	
	let fd = FileData()
	fd.Path = "names.csv"
	fd.ReadLines( { (s : String) in
	print(s)
	})
	*/
	
	static func populateDB() {
		
		var _logFileURL : URL?
		let dir: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).last! as URL
		_logFileURL = dir.appendingPathComponent("names.csv")
		
		
		//Create the database
		let db = SQLDBInstance()
		
		db.open(path: "names.sqlite", openCurrent: false)
		
		
		
		
		db.execute("CREATE TABLE Names ([Name] TEXT, [Sex] TEXT, PRIMARY KEY (Name, Sex))")
		
		var content = ""
		do {
			content = try String.init(contentsOfFile: _logFileURL!.path)
		}
		catch {}
		let allLines = content.split(separator: "\n")
		var coll : [String] = []
		for line in allLines {
			let items = String(line).trim().getPieces()
			if items.count > 3 {
				let name = items.get(1, "")
				let sex = items.get(3, "")
				if sex.implies("boy", "girl") {
					let gender = sex.implies("boy") ? "M" : "F"
					coll.append("\(name)\t\(gender)")
				}
				print("\(name), \(sex)")
			}
		}
		
		let saveColl = BulkData()
		
		coll = coll.uniqueItems()
		
		coll.forEach { (item) in
			let items = item.split(separator: "\t")
			saveColl.add(items[0].decomposedStringWithCompatibilityMapping, items[1].decomposedStringWithCompatibilityMapping)
			//saveColl.add(toAdd)
			saveColl.pushRow()
			//saveColl.append(toAdd)
		}
		
		db.bulkTransaction("INSERT OR REPLACE INTO Names (Name, Sex) VALUES (?,?)", saveColl)
		//db.bulkInsert("INSERT OR REPLACE INTO Names (Name, Sex) VALUES (?,?)", parms: saveColl)
		
		
		var names : [String] = []
		
		db.processMultiRow(rowHandler: { (row) in
			//print(row.get("name", ""))
			names.append(row.get("name", ""))
		}, "SELECT * FROM Names ORDER BY 1")
		
		print(names)
	}
}

