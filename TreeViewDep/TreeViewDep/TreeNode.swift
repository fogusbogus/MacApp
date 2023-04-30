//
//  TreeNode.swift
//  TreeViewDep
//
//  Created by Matt Hogg on 24/04/2023.
//

import Foundation

typealias KeyValue = (key: String, value: String)

/// Tree node type
class TreeNode : Identifiable, ParentTreeNodeDelegate, Hashable {
	
	subscript(_ withKey: String) -> TreeNode? {
		get {
			return nodes.first(where: { node in
				return node.key == withKey
			})
		}
	}
	
	/// Equatable to other tree nodes using the id
	/// - Parameters:
	///   - lhs: left-hand-side node
	///   - rhs: right-hand-side node
	/// - Returns: true if equal
	static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
		return lhs.id == rhs.id
	}
	
	/// Required for hashable
	/// - Parameter hasher: the hasher to combine
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	/// Provides a way for child nodes to access this, so we're not storing circular references
	/// - Returns: this
	func getNode() -> TreeNode? {
		return self
	}
	
	init() {
	}
	
	/// We need to identify our node
	private(set) var id = UUID()
	
	/// Child nodes
	var nodes: [TreeNode] = []
	
	/// This only takes effect when we have child nodes. However, keep the state of whether we can see them or not.
	var expanded: Bool = false
	
	/// Normally this would always be true, but we need the ability to hide a node
	var visible: Bool = true
	
	/// Could replace this with a view builder, but keeping things simple we need some text to show
	var text: String = "My node"
	
	/// Using the ID of each ancestor we can build a path using a common separator (in this instance a period)
	private(set) var path: String = ""
	
	/// The depth level of the node. Zero is the top.
	private(set) var level: Int = 0
	
	/// We can associate some data with the node. For speed this might be preferable to a key-based offering, but you can always just store a string value.
	var data: AnyObject?

	/// Sometimes we want a node to not be selectable
	var selectable: Bool = true
	
	/// A node potentially has a parent. If it doesn't its level is zero.
	var parent: ParentTreeNodeDelegate? {
		didSet {
			/// We might be moving to a different parent, or nil. Either way we need to recalculate some things.
			level = (parent?.getNode()?.level ?? -1) + 1
			if let parentPath = parent?.getNode()?.path {
				path = parentPath + "." + id.uuidString
			}
			else {
				path = id.uuidString
			}
		}
	}
	
	/// The associated tree
	var treeView: TreeViewDelegate? {
		didSet {
			nodes.forEach({$0.treeView = treeView})
		}
	}
	
	
	/// Identifier for the owner
	var key: String = ""

	/// Can we identify the item by the path key
	var keyPath: String {
		get {
			if let parentNode = parent?.getNode() {
				return parentNode.keyPath + "." + key
			}
			return key
		}
	}
	
	/// We provide the UI the nodes (ordered) that are visible. We already hold the nodes in our tree, no point having hidden or collapsed children in the UI.
	/// - Returns: Ordered nodes
	func getVisibleNodes() -> [TreeNode] {
		
		/// Must be visible
		guard visible else { return [] }
		var ret : [TreeNode] = [self]
		
		/// If this node is marked expanded, we need to include the child nodes
		if expanded {
			nodes.forEach { node in
				ret.append(contentsOf: node.getVisibleNodes())
			}
		}
		return ret
	}
	
	@discardableResult
	/// Append a child node with some text and data
	/// - Parameters:
	///   - text: Display text
	///   - data: Data
	/// - Returns: The tree node created
	func append(text: String, data: AnyObject? = nil, creator: (() -> TreeNode)? = nil) -> TreeNode {
		let creator = creator ?? {TreeNode()}
		let node = creator()
		node.parent = self
		node.text = text
		node.treeView = treeView
		node.data = data
		nodes.append(node)
		return node
	}
	
	@discardableResult
	/// Append some child nodes with some text
	/// - Parameter contentsOf: Array of display text
	/// - Returns: Array of tree nodes created
	func append(contentsOf: [String], creator: (() -> TreeNode)? = nil) -> [TreeNode] {
		var ret : [TreeNode] = []
		contentsOf.forEach { text in
			ret.append(append(text: text, creator: creator))
		}
		return ret
	}
	
	@discardableResult
	func appendNodes<T : TreeNode>(contentsOf: [String], creator: () -> T ) -> [T] {
		var ret: [T] = []
		contentsOf.forEach { text in
			let node = creator()
			node.text = text
			node.parent = self
			node.treeView = treeView
			nodes.append(node)
			ret.append(node)
		}
		return ret
	}
	
	
	@discardableResult
	func appendNodes<T : TreeNode>(contentsOf: [KeyValue], creator: () -> T ) -> [T] {
		var ret: [T] = []
		contentsOf.forEach { keyValue in
			let node = creator()
			node.text = keyValue.value
			node.key = keyValue.key
			node.parent = self
			node.treeView = treeView
			nodes.append(node)
			ret.append(node)
		}
		return ret
	}
	
	@discardableResult
	/// Append some child nodes with some text and data
	/// - Parameter contentsOf: Array of display text and data
	/// - Returns: Array of tree nodes created
	func append(contentsOf: [String:AnyObject], creator: (() -> TreeNode)? = nil) -> [TreeNode] {
		var ret : [TreeNode] = []
		contentsOf.forEach { (text, object) in
			ret.append(append(text: text, data: object, creator: creator))
		}
		return ret
	}
	
	/// Append some child nodes
	/// - Parameter contentsOf: Array of child nodes
	/// - Returns: Array of child nodes appended
	func append(contentsOf: [TreeNode]) -> [TreeNode] {
		var ret : [TreeNode] = []
		contentsOf.forEach { node in
			ret.append(append(node))
		}
		return ret
	}
	

	@discardableResult
	/// Removes a node
	/// - Parameter node: The node to remove
	/// - Returns: True if the node was removed (i.e. found)
	func removeNode(_ node: TreeNode) -> Bool {
		let count = nodes.count
		nodes.removeAll(where: {$0.id == node.id})
		node.parent = nil
		return nodes.count != count
	}
	
	@discardableResult
	/// Append a node with some data
	/// - Parameters:
	///   - node: The node to append
	///   - data: Node data
	/// - Returns: The created node
	private func append(_ node: TreeNode, data: AnyObject? = nil) -> TreeNode {
		if let nodeParent = node.parent?.getNode() {
			nodeParent.removeNode(node)
		}
		nodes.append(node)
		node.parent = self
		node.treeView = treeView
		node.data = data
		return node
	}
}

/// Allows a child node to talk to its parent without containing it
protocol ParentTreeNodeDelegate {
	func getNode() -> TreeNode?
}
