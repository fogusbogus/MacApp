//
//  StreetItems.swift
//  MacApp
//
//  Created by Matt Hogg on 13/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class StreetItem : NodeBase {
	
	init(_ name: String) {
		super.init()
		self.name = name
	}
	
	override func postSetup() {
		image = ImageRepo.shared["icoStreet1-1"]
	}

}

class PropertyItem: NodeBase {
	init(_ name: String) {
		super.init()
		self.name = name
	}
	
	override func postSetup() {
		image = ImageRepo.shared["icoAddress"]
	}

}

class NodeBase : NSObject {
	
	override init() {
		super.init()
		id = TreeNodeCounter.shared.getID()
		postSetup()
	}
	
	func postSetup() {
		
	}
	
	@objc dynamic var name = ""
	@objc dynamic var children : [NodeBase]?
	@objc dynamic var image : NSImage? {
		get {
			return _image
		}
		set {
			_image = newValue
		}
	}
	
	var parent : NodeBase?
	
	private dynamic var _image : NSImage?
	
	var id : String = ""
	
	@objc func isLeaf() -> Bool {
		return !hasChildren
	}
	
	var hasChildren : Bool {
		get {
			return childCount > 0
		}
	}
	
	var childCount : Int {
		get {
			return children?.count ?? 0
		}
	}
	
	func containsNode(id: String) -> Bool {
		return findNode(id: id) != nil
	}
	
	func findNode(id: String) -> NodeBase? {
		if !hasChildren {
			return nil
		}
		var found = children!.first { (node) -> Bool in
			return node.id.implies(id)
			}
		if found != nil {
			return found
		}
		
		for child in children! {
			found = child.findNode(id: id)
			if found != nil {
				return found
			}
		}
		return nil
	}
	
	func indexOfNode(id: String) -> Int? {
		if !hasChildren {
			return nil
		}
		
		for i in 0..<childCount {
			if children![i].id.implies(id) {
				return i
			}
		}
		return nil
	}
	
	func removeNode(id: String) -> Bool {
		if let i = indexOfNode(id: id) {
			children?.remove(at: i)
			if childCount == 0 {
				children = nil
			}
			requiresRefresh()
			return true
		}
		return false
	}
	
	func requiresRefresh() {
		//override this
	}
	
	/////////////
	
	func addNode(_ node: NodeBase) {
		children = children ?? []
		children!.append(node)
		node.parent = self
		requiresRefresh()
	}
}


