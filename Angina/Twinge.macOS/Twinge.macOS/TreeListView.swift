//
//  TreeListView.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 09/11/2020.
//

import Cocoa
import LoggingLib

class TreeListView: NSView, NSOutlineViewDelegate {

	@IBOutlet weak var outline: NSOutlineView!
	@IBOutlet weak var treeController: NSTreeController!
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	private var Log : IIndentLog {
		get {
			return BaseLog.shared.Log
		}
	}
	
	@objc dynamic var content = [Node]()
	
	func callOnSuperViewDidLoad() {
		
		Log.checkpoint("callOnSuperViewDidLoad", {
			outline.delegate = self
			treeController.objectClass = Node.self
			treeController.childrenKeyPath = "children"
			treeController.countKeyPath = "count"
			treeController.leafKeyPath = "isLeaf"
			
			outline.gridStyleMask = .solidHorizontalGridLineMask
			outline.autosaveExpandedItems = true
			
			treeController.bind(NSBindingName("contentArray"), to: self, withKeyPath: "content", options: nil)
			outline.bind(NSBindingName("content"), to: treeController, withKeyPath: "arrangedObjects", options: nil)
			
			//Need to expose the contents so we can add to it
			
		}, keyAndValues: [:])

	}
	
	/*
	We are using lazy loading to populate the children
	*/
	func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
		return Log.checkpoint("outlineView", { () -> Bool in
			
			guard item is Node else { return true }
			let item = item as! Node
			if item.childrenCount == "1" {
				if item.children.first is DummyNode {
					item.children.removeAll()
					
					item.children.append(contentsOf: (delegate?.getChildren(treeList: self, parentNode: item))!)
				}
			}
			return !item.isLeaf
		}, keyAndValues: ["outlineView":outlineView, "shouldExpandItem":item])
	}
	
	private var delegate: TreeListViewDelegate?
	{
		didSet {
			Log.checkpoint("delegate [Set]", {
				
			}, keyAndValues: ["newValue":delegate])
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
		return Log.checkpoint("outlineView", { () -> Bool in
			
			guard item is Node else { return true }
			let item = item as! Node
			item.children.removeAll()
			item.children.append(DummyNode())
			return true
		}, keyAndValues: ["outlineView":outlineView, "shouldCollapseItem":item])
	}
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		Log.checkpoint("init", {
			commonInit()
		}, keyAndValues: ["frame":frameRect])
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		Log.checkpoint("init", {
			commonInit()
		}, keyAndValues: ["coder":coder])
	}
	
	private func commonInit() {
		//Shit we need to do
		Log.checkpoint("commonInit", {
			Bundle.main.loadNibNamed(Self.className(), owner: self, topLevelObjects: nil)
		}, keyAndValues: [:])
		//frame = super.bounds
		//outline.autoresizingMask = [.height, .width]
	}
	
	public func setView(_ view: NSView) {
		Log.checkpoint("setView", {
			outline.frame = view.bounds
			outline.autoresizingMask = [.height, .width]
			view.addSubview(self)
		}, keyAndValues: ["view":view])
	}
	
	func addChildren(_ children: [Node]) {
		Log.checkpoint("addChildren", {
			self.content.append(contentsOf: children)
		}, keyAndValues: [:])
	}
}

protocol TreeListViewDelegate {
	func getChildren(treeList: TreeListView, parentNode: Node) -> [Node]
}
