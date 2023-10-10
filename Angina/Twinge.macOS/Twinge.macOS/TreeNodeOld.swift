//
//  TreeNode.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 26/10/2020.
//

import Foundation
import Cocoa

class TreeNodeOld {
	
	init(parent: TreeNodeOld, text: String, delegate: TreeNodeExpandCollapseDelegate? = nil) {
		self.value = NSAttributedString(string: text)
		ParentNode = parent
		expandCollapseDelegate = delegate
	}
	
	init(text: String, delegate: TreeNodeExpandCollapseDelegate? = nil) {
		self.value = NSAttributedString(string: text)
		expandCollapseDelegate = delegate
	}
	
	init(parent: TreeNodeOld, value: NSAttributedString, delegate: TreeNodeExpandCollapseDelegate? = nil) {
		self.value = value
		ParentNode = parent
		expandCollapseDelegate = delegate
	}
	
	init(value: NSAttributedString, delegate: TreeNodeExpandCollapseDelegate? = nil) {
		self.value = value
		expandCollapseDelegate = delegate
	}
	
	public var ParentNode: TreeNodeOld? = nil
	public var Level : Int {
		get {
			if ParentNode == nil {
				return 0
			}
			return ParentNode!.Level + 1
		}
	}
	
	public var Children: [TreeNodeOld] = []
	
	public var HasChildren : Bool {
		get {
			return Children.count > 0
		}
	}
	
	public var IsExpanded : Bool = true {
		didSet {
			expandCollapseDelegate?.hasChanged()
		}
	}
	
	private func validateSettings() {
		Children.forEach { (child) in
			if child.ParentNode == nil {
				child.ParentNode = self
			}
			if child.expandCollapseDelegate == nil {
				child.expandCollapseDelegate = expandCollapseDelegate
			}
			child.validateSettings()
		}
	}
	
	public func GetVisibleNodesCount() -> Int {
		validateSettings()
		var ret = 1
		if IsExpanded {
			Children.forEach { (child) in
				ret += child.GetVisibleNodesCount()
			}
		}
		return ret
	}

	public func GetVisibleNodes() -> [TreeNodeOld] {
		validateSettings()
		var ret : [TreeNodeOld] = [self]
		if IsExpanded {
			Children.forEach { (child) in
				ret.append(contentsOf: child.GetVisibleNodes())
			}
		}
		return ret
	}
	
	public var expandCollapseDelegate : TreeNodeExpandCollapseDelegate?
	
	public var value: NSAttributedString = NSAttributedString(string: "")
	
	public var expandIcon : String {
		get {
			if Children.count > 0 {
				if IsExpanded {
					return "▾"
				}
				return "‣"
			}
			return ""
		}
	}
	
	typealias ClickArea = CGRect
	public var clickArea : ClickArea?
	
	public func lineText(font: NSFont) -> (NSAttributedString, ClickArea) {
		let comp = NSMutableAttributedString()
		let ret = NSAttributedString(string: "\t".repeating(Level), attributes: [NSAttributedString.Key.font: font])
		let rect = ret.size()
		comp.append(ret)
		let icon = NSAttributedString(string: expandIcon + "\t", attributes: [NSAttributedString.Key.font: font])
		let iconSize = icon.size()
		let click = ClickArea(x: rect.width, y: 0, width: iconSize.width, height: iconSize.height)
		comp.append(icon)
		comp.append(value)
		return (comp, click)
	}
}

protocol TreeNodeExpandCollapseDelegate {
	func hasChanged()
}

extension TreeNodeOld {
	func Indent(pixelsPerIndent: Int = 16) -> Int {
		return Level * pixelsPerIndent
	}
}
