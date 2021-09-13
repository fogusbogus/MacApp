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

class setupTemp {

	init() {
		setupStreets()
	}
	
	func setupStreets() {
		let db = SQLDBInstance()
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let path: URL = dir.appendingPathComponent("Register3.sqlite")
			db.open(path: path, openCurrent: false)
			db.execute("CREATE TABLE Ward (ID INT PRIMARY KEY, Name TEXT, LatLon TEXT)")
			db.execute("CREATE TABLE Street (ID INT PRIMARY KEY, Name TEXT, WID INT, LatLon TEXT)")
			
			let baseUrl = "https://geographic.org/streetview/uk/Stroud_District/index.html"
			
			let relUrl = "https://geographic.org/streetview/uk/Stroud_District/"

			let areas = getWebpage(url: baseUrl)
			var areaId = 1, streetId = 1
			areas.forEach { tup in
				let (html, title) = tup
				let sts = getWebpage(url: relUrl + html)
				let wardRow = db.newRow(tableName: "Ward")
				//wardRow.set("id", areaId)
				wardRow.set("name", title)
				_ = db.updateTableFromSQLRow(row: wardRow, sourceTable: "Ward", idColumn: "id")
				areaId = wardRow.get("id", areaId)

				//db.execute("INSERT INTO Ward (ID, Name, LatLon) VALUES (?, ?, ?)", parms: areaId, title, "")
				sts.forEach { tup2 in
					let stRow = db.newRow(tableName: "Street")
					//stRow.set("id", streetId)
					stRow.set("name", tup2.1)
					stRow.set("wid", areaId)
					//SELECT last_insert_rowid()
					_ = db.updateTableFromSQLRow(row: stRow, sourceTable: "Street", idColumn: "id")
					//db.execute("INSERT INTO Street (ID, Name, WID, LatLon) VALUES (?,?,?,?)", parms: streetId, tup2.1, areaId, "")
					streetId += 1
				}
				areaId += 1
			}
			db.close()
		}
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
