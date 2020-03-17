//
//  TreeNodeContainerView.swift
//  MacApp
//
//  Created by Matt Hogg on 30/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import UsefulExtensions

class TreeNodeContainerView: NibView, TreeNodeViewControllerDelegate {
	
	@IBOutlet weak var tvStack: NSStackView!
	
	func addNode(node: TreeNodeView?, parent: TreeNodeView?, childIndex: Int?) {
		var insertIndex = 0
		guard parent == nil || _nodes.contains(obj: parent) else {
			return
		}
		guard node != nil else {
			return
		}
		let node = node!
		if _nodes.contains(obj: node) {
			_nodes.removeAll { (tn) -> Bool in
				return tn.id == node.id
			}
		}

		if _nodes.count == 0 {
			_nodes.append(node)
			//Add to the view as well
			
		}

		let parentIndex = _nodes.indexOf(parent) ?? 0
		
		let (first, last) = getChildRange(parentIndex: parentIndex)

		if (first + childIndex!) > last {
			//Gone beyond!!
			insertIndex = last + 1
		}
		else {
			insertIndex = first + childIndex!
		}
		
		if _nodes.count <= insertIndex {
			_nodes.append(node)
			tvStack.addSubview(node)
		}
		else {
			_nodes.insert(node, at: insertIndex)
			tvStack.insertArrangedSubview(node, at: insertIndex)
		}
	}
	
	func removeNode(node: TreeNodeView) {
		if let idx = _nodes.indexOf(node) {
			_nodes.remove(at: idx)
			node.removeFromSuperview()
		}
	}
	
	private var _nodes : [TreeNodeView] = []

	private func getChildRange(parentIndex: Int) -> (Int, Int) {
		let firstChildIndex = parentIndex + 1
		if _nodes.legalIndex(firstChildIndex) {
			if _nodes[firstChildIndex].Parent != _nodes[parentIndex] {
				return (firstChildIndex, firstChildIndex)
			}
			let last = (_nodes.lastIndex { (tn) -> Bool in
				return tn.Parent == _nodes[parentIndex]
			} ?? firstChildIndex)
			
			return (firstChildIndex, last)
		}
		else {
			return (firstChildIndex, firstChildIndex)
		}
	}
    
}


extension Array {
	func legalIndex(_ index : Int) -> Bool {
		return !(index < 0 || index >= self.count)
	}
}

extension Array where Element == TreeNodeView {
	func indexOf(_ node: TreeNodeView?) -> Int? {
		if let n = node {
			return self.firstIndex(of: n)
		}
		return nil
	}
}
