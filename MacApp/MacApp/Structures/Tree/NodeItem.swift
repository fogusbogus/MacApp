//
//  NodeItem.swift
//  MacApp
//
//  Created by Matt Hogg on 28/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions

/*
This is to be stored in an array that will be access by the tree controller.

We can insert items and raise events that something has changed.

We can hide or show items.
*/

class NodeItem : Equatable, NodeItemDelegate {
	static func == (lhs: NodeItem, rhs: NodeItem) -> Bool {
		return lhs.name == rhs.name
	}
	
	func visibilityChanged(node: NodeItem, visible: Bool) {
		Handler?.visibilityChanged(node: node, visible: visible)
	}
	
	public weak var Parent : NodeItem?
	
	private var name : String = IDProvider.shared.nextID("NodeItem", includeKeyInValue: false)
	
	private var id : Int? = nil
	
	public var data : [Any] = []
	
	public var children : [NodeItem] = []
	
	public var Handler : NodeItemDelegate?
	
	
	private var _isExpanded : Bool = false
	public var isExpanded : Bool {
		get {
			return _isExpanded
		}
		set {
			if newValue != _isExpanded {
				children.forEach { (child) in
					child._isExpanded = false
					child.visible = false
				}
			}
		}
	}
	
	public var hasChildren : Bool {
		get {
			return children.count > 0
		}
	}
	
	
	private var _visible = true
	
	public var visible : Bool {
		get {
			return _visible
		}
		set {
			if _visible != newValue {
				_visible = newValue
				Handler?.visibilityChanged(node: self, visible: _visible)
				children.forEach { (child) in
					child.visible = newValue
				}
			}
		}
	}
	
	public func addNode(node: NodeItem) {
		if !children.contains(obj: node) {
			children.append(node)
			node.Handler = self
			node.Parent = self
		}
	}
	
	public func removeAll() {
		children.forEach { (child) in
			child.removeAll()
		}
		children = []
	}
	
	public func removeNode(node: NodeItem) {
		if children.contains(obj: node) {
			children.removeAll { (item) -> Bool in
				return item == node
			}
			node.removeAll()
		}
		node.Parent = nil
		node.Handler = nil
	}
	
	
	/// Inserts a node at a given position. Returns the actual position.
	/// - Parameters:
	///   - node: The node to insert
	///   - at: The desired position
	public func insertNode(node: NodeItem, at: Int) -> Int {
		node.Handler = self
		node.Parent = self
		if at >= children.count {
			addNode(node: node)
			return children.count - 1
		}
		children.insert(node, at: at)
		return at
	}
	
	public var count : Int {
		get {
			return children.count
		}
	}
	
	public var index : Int {
		get {
			if Parent == nil {
				return 0
			}
			return Parent!.indexOf(child: self)
		}
	}
	
	public var signature : String {
		get {
			var ret = Parent?.signature ?? ""
			if ret.length(encoding: .utf8) > 0 {
				ret += "."
			}
			return ret + "\(index)"
		}
	}
	
	public func indexOf(child node : NodeItem) -> Int {
		if children.contains(obj: node) {
			return children.firstIndex(of: node)!
		}
		return -1
	}
	
}

extension NodeItem {
	func flatten() -> [NodeItem] {
		var ret : [NodeItem] = []
		ret.append(self)
		ret.append(contentsOf: children.flatten())
		return ret
	}
	
	func count(all: Bool = false) -> Int {
		if !all {
			return children.count
		}
		return children.count(all: true)
	}
}

extension Array where Element : NodeItem {
	func count(all: Bool = false) -> Int {
		if !all {
			return self.count
		}
		var ret = count
		self.forEach { (item) in
			ret += item.children.count(all: true)
		}
		return ret
	}
	
	func flatten() -> [NodeItem] {
		var ret : [NodeItem] = []
		self.forEach { (item) in
			ret.append(item)
			ret.append(contentsOf: item.children.flatten())
		}
		return ret
	}
}

protocol NodeItemDelegate {
	func visibilityChanged(node: NodeItem, visible: Bool)
}


class NodeItemIDProvider {
	
	static var nextID : String {
		return IDProvider.shared.nextID("NodeItem", includeKeyInValue: false)
	}
}
