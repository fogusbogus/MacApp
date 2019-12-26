//
//  vcElectors.swift
//  MacApp
//
//  Created by Matt Hogg on 25/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common
import DBLib

class vcElectors: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tblData: NSTableView!
	private var data : [String] = []
	
	@IBAction func selected(_ sender: NSTableView) {
	}
	
	func clearData() {
		data = []
		tblData.reloadData()
	}
	
	func loadFromProperty(db: SQLDBInstance, propertyID: Int) {
		let sql = "SELECT * FROM Elector WHERE PID = ? ORDER BY ID"
		
		clearData()
		tblData.beginUpdates()
		
		db.processMultiRow(rowHandler: { (row) in
			//			let id = row.get("id", 0)
			//			let name = row.get("displayname", "")
			
			data.append(row.toJsonString())
		}, sql, propertyID)
		tblData.endUpdates()
		tblData.reloadData()
	}
	
	//MARK: - Data source
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return data.count
	}
	
	public var RowChangedHandler: TableSelectionHasChangedDelegate?
	
	func tableViewSelectionDidChange(_ notification: Notification) {
		if tblData.selectedRow >= 0 {
			RowChangedHandler?.selectedRowChanged(self, tblData.selectedRow, jsonData: data[tblData.selectedRow])
		}
		else {
			RowChangedHandler?.selectedRowChanged(self, -1, jsonData: "")
		}
	}
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		
		//print("row: \(row)")
		if row >= data.count {
			return nil
		}
		if let tableColumn = tableColumn {
			if let index = tableView.tableColumns.firstIndex(of: tableColumn) {
				//				if data[row].count <= index {
				//					return nil
				//				}
				let json = JCollection(json: data[row])
				switch index {
				case 0:
					return json.get("id", -1)
				case 1:
					return json.get("displayname", "")
				case 2:
					return "Z" //json.get("electorCount", 0)
				default:
					return ""
				}
				//return data[row].get(index, "")
			}
		}
		return nil
	}
}
