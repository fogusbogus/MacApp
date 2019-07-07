//
//  TreeNodeView.swift
//  MacApp
//
//  Created by Matt Hogg on 24/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common

class TreeNodeView: NibView  {

	@IBOutlet weak var cvIndent: NSView!
	@IBOutlet weak var btnExpand: NSButton!
	@IBOutlet weak var lblText: NSTextField!
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	var Handler : TreeNodeViewControllerDelegate?
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		id = TreeNodeViewCounter.shared.getID()
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		id = TreeNodeViewCounter.shared.getID()
	}
	
	var Parent : TreeNodeView?
	
	func nodeIsDescendantOf(relative: TreeNodeView) -> Bool {
		var p = Parent
		while p != nil {
			if p!.id == relative.id {
				return true
			}
			p = p?.Parent
		}
		return false
	}
	
	var id = ""
	
	var Indent: Int {
		get {
			if let p = Parent {
				return p.Indent + 1
			}
			return 0
		}
	}
	
	func calcIndent(indent: Int?) {
		let indent = indent ?? Indent
		cvIndent?.constraints.first(where: { (lc) -> Bool in
			return lc.firstAttribute == .width
		})?.constant = CGFloat(24 * indent)
	}
	

	private var _nodes : [NSView] = []
	
	private var _expanded = false
	var IsExpanded : Bool {
		get {
			return _expanded
		}
		set {
			_expanded = newValue
			resizeForExpanded()
		}
	}
	
	var isVisible : Bool {
		get {
			return Parent?.isVisible ?? true
		}
	}
	
	func ExpandAll() {
		IsExpanded = true
		for node in _nodes.filter({ (vw) -> Bool in
			return vw is TreeNodeView
		}).map({ (vw) -> TreeNodeView in
			return vw as! TreeNodeView
		}) {
			node.ExpandAll()
		}
	}

	func CollapseAll() {
		IsExpanded = false
		for node in _nodes.filter({ (vw) -> Bool in
			return vw is TreeNodeView
		}).map({ (vw) -> TreeNodeView in
			return vw as! TreeNodeView
		}) {
			node.CollapseAll()
		}
	}

	private func resizeForExpanded() {
		let lines = preferredHeight
		self.constraints.first { (c) -> Bool in
			return c.firstAttribute == .height
			}?.constant = CGFloat(24 * lines)
	}
	
	var preferredHeight : Int {
		get {
			if !IsExpanded {
				return 1
			}
			let containers = _nodes.filter { (vw) -> Bool in
				return vw is TreeNodeView
				}.map { (vw) -> TreeNodeView in
					return vw as! TreeNodeView
			}
			var lines = 1
			for c in containers {
				lines += c.preferredHeight
			}
			let ordinary = _nodes.filter { (vw) -> Bool in
				return !(vw is TreeNodeView)
			}
			lines += ordinary.count
			return lines
		}
	}
}

protocol TreeNodeViewControllerDelegate {
	
	/// Nodes are held in an array by the parent controller. When we move them around
	/// we are actually moving them around the array, including when we are adding children
	/// we are in effect inserting them after the parent or sibling node.
	///
	/// - Parameters:
	///   - node: The node we are adding
	///   - parent: The parent node
	///   - childIndex: The child index to which we want to put it
	func addNode(node: TreeNodeView?, parent: TreeNodeView?, childIndex: Int?)
	
	func removeNode(node: TreeNodeView)
}

/// Providing some sort of way of uniquely identifying a TreeNode for comparison purposes
/// we'll use this simple idea of just assigning a number via a singleton
internal class TreeNodeViewCounter {
	static let shared = TreeNodeViewCounter()
	
	private init() {
	}
	
	private var _counter = UInt64(0)
	
	public func getID() -> String {
		
		let ret = "0000000000000000\(_counter)".right(16)
		_counter += 1
		return ret
		
	}
	
}
