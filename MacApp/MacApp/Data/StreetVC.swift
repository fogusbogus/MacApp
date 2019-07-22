//
//  StreetVC.swift
//  MacApp
//
//  Created by Matt Hogg on 13/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import DBLib
import Common
import RegisterDB

class StreetVC: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

	var selectedNode: NodeBase?
	
	@IBOutlet
	var selectedNodeHandler : SelectedNodeListenerDelegate?
	
//	@IBOutlet
//	var ibSelectedNodeHandler : AnyObject? {
//		get {
//			return selectedNodeHandler
//		}
//		set {
//			selectedNodeHandler = newValue as? SelectedNodeListenerDelegate
//		}
//	}
	
	@IBAction func ovAction(_ sender: Any) {
		
		if sender is NSOutlineView {
			let ov = sender as? NSOutlineView
			if let sn = ov?.selectedNode() {
	
				print("\(sn.className) \(sn.id)")
				
				if sn != selectedNode {
					selectedNode = sn
					selectedNodeHandler?.selectionChange(node: sn)
				}
			}
		}
	}
	
	@IBOutlet var treeController: NSTreeController!
	@IBOutlet weak var outlineView: NSOutlineView!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		addData()
		//outlineView.expandItem(nil, expandChildren: true)
    }
	
	override func viewDidLayout() {
		outlineView.setFrameSize(self.view.frame.size)
		print("new frame size: \(outlineView.frame.width), \(outlineView.frame.height)")
		outlineView.setNeedsDisplay(outlineView.frame)
	}
	
	func addData() {
		//add the object to the tree controller
		let root = [
			"name":"Street Items",	//This is what is shown on the screen (i.e. the Caption!!)
			"isLeaf": false			//Is this a child of something?
		]
			as [String : Any]
		
		let dict = NSMutableDictionary(dictionary: root)
		
		var rowsPD = SQLDB.queryMultiRow("SELECT * FROM PollingDistrict ORDER BY Name")
		var lst : [PollingDistrictItem] = []
		for rowPD in rowsPD {
			let pd = PollingDistrictItem(rowPD.get("Name", ""))
			pd.linkedItem = PollingDistrict(row: rowPD)
			lst.assert(pd)
		}
//
//		var rowsST = SQLDB.queryMultiRow("SELECT * FROM Street ORDER BY Name")
//		var rowsPR = SQLDB.queryMultiRow("SELECT * FROM Property ORDER BY Name")
//		var rowsEL = SQLDB.queryMultiRow("SELECT * FROM Elector ORDER BY ID")
//		var lst : [StreetItem] = []
//		for rowST in rowsST {
//			var st = StreetItem(rowST.get("Name", "<Unknown>"))
//			st.linkedItem = Street(row: rowST)
//			let rowSTID = rowST.get("ID", -1)
//			let prs = rowsPR.filter { (r) -> Bool in
//				return r.get("SID", -1) == rowSTID
//			}
//			for rowPR in prs {
//				let rowPRID = rowPR.get("ID", -1)
//				let pr = PropertyItem(Property.getDisplayNameFromSQLRow(rowPR))
//				pr.linkedItem = Property(row: rowPR)
//				st.addNode(pr)
//				let els = rowsEL.filter { (r) -> Bool in
//					return r.get("PID", -1) == rowPRID
//				}
//				for rowEL in els {
//					let el = ElectorItem(rowEL.get("DisplayName", ""))
//					el.linkedItem = Elector(row: rowEL)
//					pr.addNode(el)
//				}
//			}
//			lst.assert(st)
//		}
		dict["children"] = lst
//
//		var second = StreetItem("second")
//		second.addNode(PropertyItem("third"))
		
//		dict["children"] = [StreetItem("first"), second]
		//dict["children"] = [StreetItem("first"), second]
//		dict.setObject([StreetItems("first"), StreetItems("second")], forKey: "children" as NSCopying)
		treeController.addObject(dict)
	}
	
	//MARK: Helpers
	func isHeader(_ item: Any) -> Bool {
		if let item = item as? NSTreeNode {
			return !(item.representedObject is NodeBase)
		}
		return !(item is StreetItem)
	}
	
	//MARK: Delegate
	
	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		if isHeader(item) {
			return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self)
		} else {
			return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self)
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
		if let item = item as? NSTreeNode {
			let ro = item.representedObject
			if let nb = ro as? NodeBase {
				nb.expand()
			}
		}
		return item != nil
		//return outlineView. outlineView(outlineView, shouldExpandItem: item)
	}
}

@objc protocol SelectedNodeListenerDelegate {
	func selectionChange(node: NodeBase?)
}

extension NSOutlineView {
	func nodeAtRow(_ row: Int) -> NodeBase? {
		
		if let obj = self.item(atRow: row) {
			let tn = obj as! NSTreeNode
			return tn.representedObject as? NodeBase
		}
		return nil
	}
	
	func selectedNode() -> NodeBase? {
		return nodeAtRow(self.selectedRow)
	}
}
