//
//  main.swift
//  ImportData
//
//  Created by Matt Hogg on 23/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions
import SQLDB

Names.populateDB()

//create the postcodes.sqlite database

let PC_CREATE = "CREATE TABLE IF NOT EXISTS PostCode (ID INTEGER PRIMARY KEY AUTOINCREMENT, Code TEXT, InUse INTEGER, Introduced DATE, Terminated DATE, LatLon TEXT, EastNorth TEXT, Grid TEXT, CTID INTEGER, DTID INTEGER, WDID INTEGER)"

let CT_CREATE = "CREATE TABLE IF NOT EXISTS County (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)"

let DT_CREATE = "CREATE TABLE IF NOT EXISTS District (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Code TEXT, CTID INTEGER)"

let WD_CREATE = "CREATE TABLE IF NOT EXISTS Ward (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, Code TEXT, CTID INTEGER, DTID INTEGER)"

let db = SQLDBInstance()

db.open(path: "postcodes.sqlite", openCurrent: true)

db.execute(PC_CREATE)
db.execute(CT_CREATE)
db.execute(DT_CREATE)
db.execute(WD_CREATE)

var _logFileURL : URL?
let dir: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).last! as URL
_logFileURL = dir.appendingPathComponent("GL Postcodes.csv")

let content = try String.init(contentsOfFile: _logFileURL!.path) ?? ""
var allLines = content.split(separator: "\n")
var coll : [String] = []

let _pc = Lookup(db: db, name: "PostCode", column: "Code")
let _ct = Lookup(db: db, name: "County")
let _dt = Lookup(db: db, name: "District")
let _wd = Lookup(db: db, name: "Ward")

//First row contains the header names
let cols = allLines[0].decomposedStringWithCompatibilityMapping.getPieces()
allLines.remove(at: 0)

let PC_UPDATE = "UPDATE PostCode SET InUse=?, Introduced=?, Terminated=?, LatLon=?, EastNorth=?, Grid=?, CTID=?, DTID=?, WDID=? WHERE ID = ?"

let DT_UPDATE = "UPDATE District SET Code=?, CTID=? WHERE ID=?"
let WD_UPDATE = "UPDATE Ward SET Code=?, CTID=?, DTID=? WHERE ID=?"

var toUpdate : [Array<Any?>] = []

var bulk = BulkData()

for line in allLines {
	let data = String(line).trim().getPieces()
	//let pcid = _pc.lookupID(name: data.get(0, ""))
	let dtid = _dt.lookupID(name: data.get(cols, "District", ""))
	let ctid = _ct.lookupID(name: data.get(cols, "County", ""))
	let wdid = _wd.lookupID(name: data.get(cols, "Ward", ""))
		
	//Postcode data
	let inuse = data.get(cols, "In Use?", "No").implies("Yes") ? 1 : 0
	var latlon = data.get(cols, "Latitude", "") + "," + data.get(cols, "Longitude", "")
	if latlon == "," {
		latlon = ""
	}
	var eastnorth = data.get(cols, "Easting", "") + "," + data.get(cols, "Northing", "")
	if eastnorth == "," {
		eastnorth = ""
	}
	let grid = data.get(cols, "Grid Ref", "")
	
	//County doesn't need updating
	//District needs updating
	let dtCode = data.get(cols, "District Code", "")
	let wdCode = data.get(cols, "Ward Code", "")
	
	var intro = data.get(cols, "Introduced", "")
	var term = data.get(cols, "Terminated", "")
	
	if intro == "1980-01-01" {
		intro = ""
	}
	if term == "1980-01-01" {
		term = ""
	}

	if dtid.1 && !dtCode.isEmptyOrWhitespace() {
		//Let's update the ward
		db.execute(DT_UPDATE, parms: dtCode, ctid.0, dtid.0)
	}
	if wdid.1 && !wdCode.isEmptyOrWhitespace() {
		//Let's update the ward
		db.execute(WD_UPDATE, parms: wdCode, ctid.0, dtid.0, wdid.0)
	}
	
	bulk.add(data.get(0, ""), inuse, intro, term, latlon, eastnorth, grid, ctid.0, dtid.0, wdid.0)
	bulk.pushRow()
	//toUpdate.append([data.get(0, ""), inuse, intro, term, latlon, eastnorth, grid, ctid.0, dtid.0, wdid.0])
	
	//db.execute(PC_UPDATE, parms: inuse, data.get(15, ""), data.get(16, ""), latlon, eastnorth, grid, ctid.0, dtid.0, wdid.0, pcid.0)
}

let PC_INSERT = "INSERT INTO PostCode (Code, InUse, Introduced, Terminated, LatLon, EastNorth, Grid, CTID, DTID, WDID) VALUES (?,?,?,?,?,?,?,?,?,?)"

db.bulkTransaction(PC_INSERT, bulk) //(PC_INSERT, parms: toUpdate)

/*

Tables to create:

	PostCode:
		Code
		InUse
		Introduced
		Terminated
		LatLon
		EastNorth
		Grid
		CTID
		DTID
		WDID

	County:
		ID
		Name

	District:
		ID
		Name
		Code
		COID

	Ward:
		ID
		Name
		Code
		DTID
		COID

	Constituency:
		ID
		Name
		
	

*/
