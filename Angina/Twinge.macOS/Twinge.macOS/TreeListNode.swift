//
//  TreeListNode.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 09/11/2020.
//

import Cocoa

class TreeListNode: NSObject {

	dynamic var name: String = ""
	
	func isLeaf() -> Bool {
		return true
	}
	
}

@objc public class DummyNode : Node {
	init() {
		super.init(value: "", children: [])
	}
}

@objc public class Node : NSObject {
	@objc var value : String
	@objc var children : [Node]
	
	@objc var childrenCount: String? {
		let count = children.count
		guard count > 0 else { return nil }
		return "\(count)"
	}
	
	@objc var count: Int {
		children.count
	}
	
	@objc var isLeaf: Bool {
		children.isEmpty
	}
	
	func isDescendant(_ of: Node) -> Bool {
		if of == self {
			return true
		}
		return children.first { (node) -> Bool in
			node.isDescendant(of)
		} != nil
	}
	
	init(value: String, children: [Node] = []) {
		self.value = value
		self.children = children
	}
	
	init(value: String, lazyChildLoad: Bool = false) {
		self.value = value
		if lazyChildLoad {
			self.children = [DummyNode()]
		}
		else {
			self.children = []
		}
	}

	
	func loadChildren() { }
	
	func addNode(_ single: Node) {
		children.append(single)
	}
	
	func addNode(_ multiple: [Node]) {
		children.append(contentsOf: multiple)
	}
	
	func removeNode(_ node: Node) {
		if children.contains(obj: node) {
			children.removeAll { (child) -> Bool in
				return child == node
			}
		}
		else {
			children.forEach { (child) in
				child.removeNode(node)
			}
		}
	}
}
