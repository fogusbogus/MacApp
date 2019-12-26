//
//  vcProperties.swift
//  MacApp
//
//  Created by Matt Hogg on 23/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common
import DBLib

class vcProperties: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	@IBOutlet var mainView: NSView!
	@IBOutlet weak var headers: NSTableHeaderView!
	@IBOutlet weak var tblData: NSTableView!
	@IBOutlet weak var col1: NSTableColumn!
	@IBOutlet weak var col2: NSTableColumn!
	
	@IBAction func selected(_ sender: NSTableView) {
		//Something has been selected in the table
		let last = _selectedRow ?? -1
		if sender.selectedRow != last {
			RowChangedHandler?.selectedRowChanged(self, sender.selectedRow, jsonData: data[sender.selectedRow])
		}
		_selectedRow = sender.selectedRow < 0 ? nil : sender.selectedRow
	}
	
	private var _selectedRow: Int?
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		col1.isHidden = true
    }
	
	var data : [String] = []
	
	private func addRow(id: Int, propertyName: String) {
		
		tblData.beginUpdates()
		
		let newData = [id, propertyName] as [Any]
		//data.append(newData)
		let newRow = IndexSet([data.count - 1])
		
		tblData.insertRows(at: newRow, withAnimation: .slideDown)
		
		tblData.endUpdates()
	}
	
	func clearData() {
		data = []
		tblData.reloadData()
	}
	
	func loadFromStreet(db: SQLDBInstance, streetID: Int) {
		let sql = "SELECT * FROM Property WHERE SID = ? ORDER BY ID"
		
		clearData()
		tblData.beginUpdates()
		
		db.processMultiRow(rowHandler: { (row) in
//			let id = row.get("id", 0)
//			let name = row.get("displayname", "")
			
			data.append(row.toJsonString())
		}, sql, streetID)
		tblData.endUpdates()
		tblData.reloadData()
	}
	
	/*
	tblData
	--> Table column
		--> Table cell view
			--> Text cell
	--> Table column
	*/
    
	
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
					return json.get("electorCount", 0)
				default:
					return ""
				}
				//return data[row].get(index, "")
			}
		}
		return nil
	}
}


protocol TableSelectionHasChangedDelegate {
	func selectedRowChanged(_ owner: Any, _ row: Int, jsonData: String?)
}
