//
//  FileNode.swift
//  MacApp
//
//  Created by Matt Hogg on 15/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

class FileNode : TreeNode, TreeNodeEventsDelegate {
	func canMoveChild(node: TreeNode, child: TreeNode?, from: Int, to: Int) -> Bool {
		return false
	}
	
	func childMoved(node: TreeNode, child: TreeNode, from: Int, to: Int) {
		
	}
	
	func canAddChild(node: TreeNode, child: TreeNode?) -> Bool {
		return true
	}
	
	func childAdded(node: TreeNode, child: TreeNode) {
		
	}
	
	func canRemoveChild(node: TreeNode, child: TreeNode?) -> Bool {
		return true
	}
	
	func childRemoved(node: TreeNode, child: TreeNode) {
		
	}
	
}
