//
//  StreetVC.swift
//  MacApp
//
//  Created by Matt Hogg on 13/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

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
		
		var second = StreetItem("second")
		second.addNode(PropertyItem("third"))
		
		dict["children"] = [StreetItem("first"), second]
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
