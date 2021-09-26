//
//  NewRegisterApp.swift
//  NewRegister
//
//  Created by Matt Hogg on 02/09/2021.
//

import SwiftUI
import UsefulExtensions
import SQLDB
import LoggingLib

@main
struct NewRegisterApp: App {
    let persistenceController = PersistenceController.shared
	let setup = setupTemp()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct NameImport: Codable {
	public var names: [String]
}

extension String {
	func titleCase() -> String {
		if self.length() == 0 {
			return ""
		}
		var chrs = Array(self.lowercased())
		let initial = chrs.first!.uppercased()
		chrs.remove(at: 0)
		return String(initial + chrs)
	}
}

class setupTemp {

	init() {
		setupStreets()
	}
	
	private var _surnames : [String] = []
	private var _forenamesM : [String] = []
	private var _forenamesF : [String] = []

	func readFromFile(_ filename: String) -> Data {
		
		if let path = Bundle.main.path(forResource: filename.before("."), ofType: filename.after(".")) {
			do {
				return try String(contentsOfFile: path, encoding: .utf8).data(using: .utf8)!
			} catch let error {
				// Handle error here
				print(error)
			}
		}
		return Data()
	}
	
	struct PersonStruct {
		var gender: String
		var forename: String
		var middleNames: String
		var surname: String
		
		var name: String {
			get {
				let mn = middleNames.splitToArray(" ").map {$0.substring(from: 0, length: 1)}.joined(separator: ". ")
				return "\(forename) \(mn) \(surname)"
			}
		}
	}
	func getPropertyElectors(_ happyFamilies: Bool = true) -> [PersonStruct] {
		if _surnames.count == 0 {
			let filename = "surnames.json"
			let dec = JSONDecoder()
			dec.dateDecodingStrategy = .iso8601
			let data = readFromFile(filename)
			
			do {
				let names = try! dec.decode(NameImport.self, from: data)
				_surnames = names.names
			}
			catch {
				
			}
		}
		if _forenamesM.count == 0 {
			let filename = "males.json"
			let dec = JSONDecoder()
			dec.dateDecodingStrategy = .iso8601
			let data = readFromFile(filename)
			
			do {
				let names = try! dec.decode(NameImport.self, from: data)
				_forenamesM = names.names
			}
			catch {
				
			}
		}
		if _forenamesF.count == 0 {
			let filename = "surnames.json"
			let dec = JSONDecoder()
			dec.dateDecodingStrategy = .iso8601
			let data = readFromFile(filename)
			
			do {
				let names = try! dec.decode(NameImport.self, from: data)
				_forenamesF = names.names
			}
			catch {
				
			}
		}
		
		//Let's decide if we are all with the same surname or not
		var candSurnames : [String] = []
		if !happyFamilies {
			candSurnames.append(contentsOf: _surnames)
		}
		else {
			candSurnames.append(_surnames.randomElement()!)
		}
		
		var usedForenames: [String] = []
		var ret: [PersonStruct] = []
		
		for i in 0..<Int.random(in: 1...7) {
			let sn = candSurnames.randomElement()!.titleCase()
			let female = Int.random(in: 0...1) == 0
			let candNames = female ? _forenamesF : _forenamesM
			var fn = candNames.randomElement()!.titleCase()
			while usedForenames.contains(fn) {
				fn = candNames.randomElement()!.titleCase()
			}
			var mns : [String] = []
			for _ in 0..<Int.random(in: 0...4) {
				var mn = candNames.randomElement()!.titleCase()
				while mn == fn || mns.contains(mn) {
					mn = candNames.randomElement()!.titleCase()
				}
				mns.append(mn)
			}
			ret.append(PersonStruct(gender: female ? "F":"M", forename: fn, middleNames: mns.joined(separator: " "), surname: sn))
		}
		return ret
	}
	
	func setupStreets() {
		
		/*
		
		let db = SQLDBInstance()
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let path: URL = dir.appendingPathComponent("Register4.sqlite")
			db.open(path: path, openCurrent: false)
			db.execute("CREATE TABLE District (ID INT PRIMARY KEY, Name TEXT)")
			db.execute("CREATE TABLE Ward (ID INT PRIMARY KEY, Name TEXT, LatLon TEXT, [DID] INT)")
			db.execute("CREATE TABLE Street (ID INT PRIMARY KEY, Name TEXT, WID INT, [DID] INT, LatLon TEXT)")
			db.execute("CREATE TABLE Property (ID INT PRIMARY KEY, Name TEXT, SID INT, WID INT, [DID] INT, LatLon TEXT)")
			db.execute("CREATE TABLE Elector (ID INT PRIMARY KEY, Name TEXT, Forename TEXT, MiddleNames TEXT, Surname TEXT, PID INT, SID INT, WID INT, [DID] INT, Gender TEXT)")

			let baseUrl = "https://geographic.org/streetview/uk/Stroud_District/index.html"
			
			let relUrl = "https://geographic.org/streetview/uk/Stroud_District/"

			let district = db.newRow(tableName: "DISTRICT")
			district.set("Name", "Stroud")
			_ = db.updateTableFromSQLRow(row: district, sourceTable: "DISTRICT", idColumn: "ID")
			let did = district.get("ID", -1)
			
			let areas = getWebpage(url: baseUrl)
			var areaId = 1, streetId = 1
			areas.forEach { tup in
				let (html, title) = tup
				let sts = getWebpage(url: relUrl + html)
				let wardRow = db.newRow(tableName: "Ward")
				//wardRow.set("id", areaId)
				wardRow.set("name", title)
				wardRow.set("did", did)
				_ = db.updateTableFromSQLRow(row: wardRow, sourceTable: "Ward", idColumn: "id")
				areaId = wardRow.get("id", areaId)

				//db.execute("INSERT INTO Ward (ID, Name, LatLon) VALUES (?, ?, ?)", parms: areaId, title, "")
				sts.forEach { tup2 in
					let stRow = db.newRow(tableName: "Street")
					//stRow.set("id", streetId)
					stRow.set("name", tup2.1)
					stRow.set("wid", areaId)
					stRow.set("did", did)
					//SELECT last_insert_rowid()
					_ = db.updateTableFromSQLRow(row: stRow, sourceTable: "Street", idColumn: "id")
					//db.execute("INSERT INTO Street (ID, Name, WID, LatLon) VALUES (?,?,?,?)", parms: streetId, tup2.1, areaId, "")
					streetId = stRow.get("id", -1)
					
					//Now we need a random number of properties
					for propNo in 1...Int.random(in: 4..<61) {
						let prRow = db.newRow(tableName: "Property")
						prRow.set("name", String(describing: propNo))
						prRow.set("wid", areaId)
						prRow.set("sid", streetId)
						prRow.set("did", did)
						_ = db.updateTableFromSQLRow(row: prRow, sourceTable: "Property", idColumn: "id")
						let propId = prRow.get("id", -1)
						let electors = getPropertyElectors(Int.random(in: 0..<100) < 80)
						
						electors.forEach { ps in
							let elRow = db.newRow(tableName: "Elector")
							elRow.set("pid", propId)
							elRow.set("wid", areaId)
							elRow.set("sid", streetId)
							elRow.set("did", did)
							elRow.set("forename", ps.forename)
							elRow.set("middlenames", ps.middleNames)
							elRow.set("surname", ps.surname)
							elRow.set("gender", ps.gender)
							elRow.set("name", ps.name)
							db.updateTableFromSQLRow(row: elRow, sourceTable: "Elector", idColumn: "id")
						}
					}
				}
				areaId += 1
			}
			db.close()
		}
*/
	}
	
	func getWebpage(url: String) -> [(String, String)] {
		if let uri = URL(string: url) {
			do {
				let contents = try String(contentsOf: uri)
				return contents.splitToArray("<li><a href=\"").filter({ s in
					return !s.starts(with: "<")
				}).map { s -> (String, String) in
					let link = s.before("\"")
					let name = s.after(">").before("<")
					return (link, name)
				}
			}
			catch let err {
				print(err)
			}
		}
		return []
	}

}
