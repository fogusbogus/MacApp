//
//  ViewController.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 12/10/2020.
//

import Cocoa
import UsefulExtensions

class ViewController: NSViewController, LocalizationExtension, NSTableViewDataSource, TreeNodeExpandCollapseDelegate, NSTableViewDelegate {
	func hasChanged() {
		_visibleRows.removeAll()
		table.reloadData()
		self.view.setNeedsDisplay(self.view.frame)
	}
	
	@IBOutlet var tv: TreeListView!
	//TODO: Double-click of row, or single-click of arrow should expand/collapse toggle
	@IBOutlet weak var table: NSTableView!
	@IBAction func doubleClick(_ sender: Any) {
		guard table.selectedRow >= 0 else { return }
		_visibleRows[table.selectedRow].IsExpanded = !_visibleRows[table.selectedRow].IsExpanded
	}
	@IBAction func singleClick(_ sender: Any) {
		let mouse = NSEvent.mouseLocation
		let mp = mouse.relativeTo(view: table)
		
		let omp = NSPoint(x: mp.x, y: table.frame.height - mp.y) // - table.headerView!.frame.height)
		let row = table.row(at: omp), col = table.column(at: omp)
		
		print("---------------------------")

		print("mouse: \(mouse)")
		print("mp   : \(mp)")
		print("omp  : \(omp)")
		print("row  : \(row)")

		if row >= 0 {
			let vr = _visibleRows[row]
			print("area : \(vr.clickArea!)")

			if vr.clickArea!.contains(CGPoint(x: omp.x, y: 0)) {
				vr.IsExpanded = !vr.IsExpanded
			}
		}
	}
	
	func allFrames(view: NSView) -> [Int:CGRect] {
		var ret : [Int:CGRect] = [:]
		var view : NSView? = view
		while view != nil {
			ret[ret.count] = view!.window?.frame
			view = view!.superview
		}
		return ret
	}
	private var _visibleRows : [TreeNodeOld] = []
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		if tableView == table {
			if _visibleRows.count > 0 {
				return _visibleRows.count
			}
			items.forEach { (item) in
				_visibleRows.append(contentsOf: item.GetVisibleNodes())
			}
			return _visibleRows.count
		}
		return 0
	}
	
	var items : [TreeNodeOld] = []
	
	var font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
	
	func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		
		if tableView == table {
			let item = _visibleRows[row]
			let itemValue = item.lineText(font: font)
			item.clickArea = itemValue.1
			return itemValue.0
		}
		return nil
	}
	
	@IBOutlet weak var mnuMain: NSMenuItem!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		//		let app = _resStr(file: "Application", cat: "Application", id: "Title")
		//		print(app)
		//		let title = _resStr(file: "Application", cat: "Application", id: "Name")
		//		mnuMain.title = title
		
		self.view.subviews.compactMap { (vw) -> NSMenuItem? in
			return vw as? NSMenuItem
		}.filter { (mnu) -> Bool in
			return mnu.title.contains("Twinge.macOS")
		}.forEach { (mnu) in
			mnu.title = mnu.title.replacingOccurrences(of: "Twinge.macOS", with: "Twinge")
		}
		
		//set up our items here
		//		let top = TreeNode(text: "Top", delegate: self)
		//		items.append(top)
		//		top.Children.append(TreeNode(parent: top, text: "First", delegate: self))
		//		top.Children.append(TreeNode(parent: top, text: "Second", delegate: self))
		//		top.Children.append(TreeNode(parent: top, text: "Third", delegate: self))
		//		let next = TreeNode(text: "Top #2", delegate: self)
		//		items.append(next)
		//		next.Children.append(TreeNode(parent: next, text: "First", delegate: self))
		//		next.Children.append(TreeNode(parent: next, text: "Second", delegate: self))
		
		tv.addChildren([Node(value: "First", children: [])])
		
		let top = TreeNodeOld(text: "Top", delegate: self)
		items.append(top)
		top.Children.append(TreeNodeOld(text: "First"))
		top.Children.append(TreeNodeOld(text: "Second"))
		top.Children.append(TreeNodeOld(text: "Third"))
		let next = TreeNodeOld(text: "Top #2", delegate: self)
		items.append(next)
		next.Children.append(TreeNodeOld(text: "First"))
		next.Children.append(TreeNodeOld(text: "Second"))
		
		tv.setView(self.view)
		tv.callOnSuperViewDidLoad()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	
}

extension NSPoint {
	func relativeTo(view: NSView) -> NSPoint {
		let pt = view.window?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
		return NSPoint(x: self.x - pt.origin.x, y: self.y - pt.origin.y)
	}
}
