//
//  TreeView.swift
//  TreeViewDep
//
//  Created by Matt Hogg on 24/04/2023.
//

import Foundation

/// Treeview class
class TreeView : TreeViewDelegate {
	
	subscript(_ withKey: String) -> TreeNode? {
		get {
			if withKey.contains(where: {$0 == "."}) {
				var parts = withKey.split(whereSeparator: {$0 == "."}).map({String(describing: $0)})
				var candidate = nodes.first(where: {$0.key == parts[0]})
				parts.removeFirst()
				while candidate != nil && parts.count > 0 {
					candidate = candidate?[parts[0]]
					parts.removeFirst()
				}
				return candidate
			}
			return nodes.first(where: { node in
				return node.key == withKey
			})
		}
	}
	
	/// Returns the selected node as a delegated function
	/// - Returns:
	func getSelectedNode() -> TreeNode? {
		return selectedNode
	}
	
	/// Something has changed
	func requiresUpdate() {
		self.stale = true
	}
	
	/// The child nodes
	var nodes: [TreeNode] = []
	
	/// The current selected node
	var selectedNode: TreeNode? {
		didSet {
			self.stale = true
			notifyDelegate?.selectionChanged(node: selectedNode, data: selectedNode?.data)
		}
	}
	
	/// Does any UI warrant an update?
	var stale: Bool = true {
		didSet {
			if stale {
				viewDelegate?.update()
				if viewDelegate != nil {
					stale = false
				}
			}
		}
	}
	
	/// Something might be watching us, so provide a path to update
	var viewDelegate: TreeViewUIDelegate?
	/// Something might want notification of updates or selection changes
	var notifyDelegate: TreeViewNotifier?
	
	/// Because expanding and collapsing nodes can change a particular view of the nodes, we need to offer the ability to grab what is visible
	/// - Returns: Visible nodes, in order
	func getVisibleNodes() -> [TreeNode] {
		var ret: [TreeNode] = []
		nodes.forEach { node in
			ret.append(contentsOf: node.getVisibleNodes())
		}
		while selectedNode != nil && (!ret.contains(where: {$0.id == selectedNode?.id}) || !selectedNode!.selectable) {
			if let parent = selectedNode?.parent?.getNode() {
				selectedNode = parent
			}
			else {
				selectedNode = nil
			}
		}
		return ret
	}
	
	@discardableResult
	/// Append a TreeNode type to our node collection
	/// - Parameters:
	///   - text: Initial text
	///   - creator: A TreeNode creator closure. You can use this to create derived classes of TreeNode with your own spin on them!
	/// - Returns: TreeNode type
	func append(text: String, creator: (() -> TreeNode)? = nil) -> TreeNode {
		let creator = creator ?? {TreeNode()}
		let node = creator()
		node.parent = nil
		node.text = text
		node.treeView = self
		nodes.append(node)
		return node
	}
	
	@discardableResult
	func append(contentsOf: [String], creator: (() -> TreeNode)? = nil) -> [TreeNode] {
		var ret : [TreeNode] = []
		contentsOf.forEach { text in
			ret.append(append(text: text, creator: creator))
		}
		return ret
	}
	
	func append(contentsOf: [TreeNode]) -> [TreeNode] {
		var ret : [TreeNode] = []
		contentsOf.forEach { node in
			ret.append(append(node))
		}
		return ret
	}
	
	@discardableResult
	func removeNode(_ node: TreeNode) -> Bool {
		let count = nodes.count
		nodes.removeAll(where: {$0.id == node.id})
		node.parent = nil
		return nodes.count != count
	}
	
	@discardableResult
	func append(_ node: TreeNode) -> TreeNode {
		if let nodeParent = node.parent?.getNode() {
			nodeParent.removeNode(node)
		}
		nodes.append(node)
		node.parent = nil
		node.treeView = self
		return node
	}
	
	@discardableResult
	func appendNodes<T : TreeNode>(contentsOf: [String], creator: () -> T ) -> [T] {
		var ret: [T] = []
		contentsOf.forEach { text in
			let node = creator()
			node.text = text
			node.parent = nil
			node.treeView = self
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
			node.parent = nil
			node.treeView = self
			nodes.append(node)
			ret.append(node)
		}
		return ret
	}
	

}

protocol TreeViewDelegate {
	func requiresUpdate()
	func getSelectedNode() -> TreeNode?
}

protocol TreeViewUIDelegate {
	func update()
	func select(node: TreeNode?)
}
