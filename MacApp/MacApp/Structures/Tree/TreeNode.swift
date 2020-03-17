//
//  TreeNode.swift
//  MacApp
//
//  Created by Matt Hogg on 15/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions
import Cocoa

class TreeNode : NSView {
	static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
		return lhs._id == rhs._id
	}
	
	private var _parent : TreeNode?
	var Parent : TreeNode? {
		get {
			return _parent
		}
	}
	
	var Visible: Bool {
		get {
			if let p = Parent {
				if !p.Expanded {
					return false
				}
				return p.Visible
			}
			return true
		}
	}
	
	func forceVisibility(visible: Bool) {
		isHidden = visible
		for node in _nodes {
			node.forceVisibility(visible: Expanded)
		}
	}
	
	//Visibility - this is entirely dependent on the parent's Expanded value
	private func setVisibility() {
		if Visible {
			isHidden = false
		}
		for node in _nodes {
			node.forceVisibility(visible: Expanded)
		}
	}
	
	private var _id = ""
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_id = TreeNodeCounter.shared.getID()
	}
	
	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
	}
	
	//Nodes as a collection
	private var _nodes : [TreeNode] = []
	
	var Nodes : [TreeNode] {
		get {
			return _nodes
		}
	}
	
	var First : TreeNode? {
		get {
			if _nodes.count > 0 {
				return _nodes[0]
			}
			return nil
		}
	}
	
	var Last : TreeNode? {
		get {
			if _nodes.count > 0 {
				return _nodes[0]
			}
			return nil
		}
	}
	
	private var _expanded : Bool = false
	var Expanded : Bool {
		get {
			return _expanded
		}
	}
}


protocol TreeNodeEventsDelegate {
	func canMoveChild(node: TreeNode, child: TreeNode?, from: Int, to: Int) -> Bool
	func childMoved(node: TreeNode, child: TreeNode, from: Int, to: Int)
	func canAddChild(node: TreeNode, child: TreeNode?) -> Bool
	func childAdded(node: TreeNode, child: TreeNode)
	func canRemoveChild(node: TreeNode, child: TreeNode?) -> Bool
	func childRemoved(node: TreeNode, child: TreeNode)
}

/// Providing some sort of way of uniquely identifying a TreeNode for comparison purposes
/// we'll use this simple idea of just assigning a number via a singleton
internal class TreeNodeCounter {
	static let shared = TreeNodeCounter()
	
	private init() {
	}
	
	private var _counter = UInt64(0)
	
	public func getID() -> String {
		
		let ret = "0000000000000000\(_counter)".right(16)
		_counter += 1
		return ret
		
	}
	
}
//
//extension TreeNode {
//func indexOf(_ item: TreeNode) -> Int {
//return self._children.firstIndex(of: item) ?? -1
//}
//}



/*
class TreeNode : Equatable {

subscript(_ index: Int) -> TreeNode? {
get {
guard index >= 0 && index < count else {
return nil
}
return _children[index]
}
}

subscript(_ id: String) -> TreeNode? {
get {
return _children.first { (tn) -> Bool in
return tn._id == id
}
}
}

public var count : Int {
get {
return _children.count
}
}

static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
return lhs.id == rhs.id
}

func getSignature() -> String {
return (Parent?.getSignature())! + ".\(String(describing: Parent?.indexOf(self)))"
}

public var Value : Any?
private var _children : [TreeNode] = []
weak var Parent : TreeNode?
private var _id = ""

var Handler : TreeNodeEventsDelegate?

public var Name = ""

public var id : String {
get {
return _id
}
}

init(_ value: Any? = nil) {
_id = TreeNodeCounter.shared.getID()
Value = value
}

func addChild(_ node: TreeNode) {
if let h = Handler {
if !h.canAddChild(node: self, child: node) || !h.canRemoveChild(node: self, child: node) {
return
}
}
node.Parent?.removeChild(node)
_children.append(node)
node.Parent = self
Handler?.childAdded(node: self, child: node)
}

func removeChild(_ node: TreeNode) {
if let h = Handler {
if !h.canRemoveChild(node: self, child: node) {
return
}
}
let index = self.indexOf(node)
if index >= 0 {
_children.remove(at: index)
}
Handler?.childRemoved(node: self, child: node)
}

func movePrevious() {
guard Parent != nil else {
return
}
let myIndex = Parent!.indexOf(self)
if let h = Handler {
if !h.canMoveChild(node: Parent!, child: self, from: myIndex, to: myIndex - 1) {
return
}
}
if myIndex > 0 {
Parent!.moveChild(from: myIndex, to: myIndex - 1)
}
}

func moveNext() {
guard Parent != nil else {
return
}
let myIndex = Parent!.indexOf(self)
if let h = Handler {
if !h.canMoveChild(node: Parent!, child: self, from: myIndex, to: myIndex + 1) {
return
}
}
if myIndex < count - 1 {
Parent!.moveChild(from: myIndex, to: myIndex + 1)
}
}

func moveChild(from: Int, to: Int) {
guard from >= 0 && from < count else {
return
}
guard to >= 0 && to < count else {
return
}
guard from != to else {
return
}

let node = _children.remove(at: from)
_children.insert(node, at: to)
Handler?.childMoved(node: self, child: node, from: from, to: to)
}

}
*/
