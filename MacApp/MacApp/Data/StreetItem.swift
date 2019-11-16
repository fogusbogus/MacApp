//
//  StreetItems.swift
//  MacApp
//
//  Created by Matt Hogg on 13/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB

class PollingDistrictItem : NodeBase {
	
	init(_ name: String) {
		super.init()
		self.name = name
	}
	
	override func postSetup() {
		image = ImageRepo.shared["icoGlobe"]
	}
	
	override func expand() {
		super.expand()
		print("PD: I'm expanding")
	}
	
	override func getChildItems() {
		super.getChildItems()
		
		if let st = linkedItem as? PollingDistrict {
			let childIDs = st.getChildIDs()
			var toSet : [NodeBase] = []
			for childID in childIDs {
				var child = children?.first(where: { (nb) -> Bool in
					return nb.linkedItem?.ID == childID
				})
				if child == nil {
					let st = Street(db: Databases.shared.Register, childID)
					child = StreetItem(st.Name)
					child?.linkedItem = st
				}
				toSet.append(child!)
			}
			children?.removeAll()
			addNodes(toSet)
		}
	}
	
}

class StreetItem : NodeBase {
	
	init(_ name: String) {
		super.init()
		self.name = name
	}
	
	override func postSetup() {
		image = ImageRepo.shared["icoStreet1-1"]
	}
	
	override func expand() {
		super.expand()
		print("ST: I'm expanding")
	}

	override func getChildItems() {
		super.getChildItems()
		
		if let st = linkedItem as? Street {
			let childIDs = st.getChildIDs()
			var toSet : [NodeBase] = []
			for childID in childIDs {
				var child = children?.first(where: { (nb) -> Bool in
					return nb.linkedItem?.ID == childID
				})
				if child == nil {
					let pr = Property(db: Databases.shared.Register, childID)
					child = PropertyItem(pr.getDisplayName())
					child?.linkedItem = pr
				}
				toSet.append(child!)
			}
			children?.removeAll()
			addNodes(toSet)
		}
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

	override func expand() {
		super.expand()
	}

	override func getChildItems() {
		super.getChildItems()
		
		if let st = linkedItem as? Property {
			let childIDs = st.getChildIDs()
			var toSet : [NodeBase] = []
			for childID in childIDs {
				var child = children?.first(where: { (nb) -> Bool in
					return nb.linkedItem?.ID == childID
				})
				if child == nil {
					let el = Elector(db: Databases.shared.Register, childID)
					child = ElectorItem(el.DisplayName)
					child?.linkedItem = el
				}
				if !child!.isLeaf() {
					child!.children?.append(NodeBase())
				}
				toSet.append(child!)
			}
			children?.removeAll()
			addNodes(toSet)
		}
	}
}

class ElectorItem: NodeBase {
	init(_ name: String) {
		super.init()
		self.name = name
	}
	
	override func postSetup() {
		image = ImageRepo.shared["Elector"]
	}
	
	override func expand() {
		super.expand()
	}
	
	override func getChildItems() {
		super.getChildItems()
		
		if let st = linkedItem as? Property {
			let childIDs = st.getChildIDs()
			var toSet : [NodeBase] = []
			for childID in childIDs {
				var child = children?.first(where: { (nb) -> Bool in
					return nb.linkedItem?.ID == childID
				})
				if child == nil {
					let el = Elector(db: Databases.shared.Register, childID)
					child = ElectorItem(el.DisplayName)
					child?.linkedItem = el
				}
				toSet.append(child!)
			}
			children?.removeAll()
			addNodes(toSet)
		}
	}
	
	override func updateText() {
		if let el = linkedItem as? Elector {
			name = "\(el.Forename) \(el.MiddleName) \(el.Surname)".removeMultipleSpaces(true)
		}
		else {
			name = ""
		}
	}
}

class NodeBase : NSObject, TableBasedDelegate {
	func dataChanged() {
		updateText()
	}
	
	internal func updateText() {
		
	}
	
	private var _linkedItem : TableBased<Int>?
	
	public var linkedItem : TableBased<Int>? {
		get {
			return _linkedItem
		}
		set {
			_linkedItem = newValue
			newValue?.handler = self
		}
	}
	
	override init() {
		super.init()
		id = TreeNodeCounter.shared.getID()
		postSetup()
	}
	
	func getChildItems() {
		
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
		if let li = linkedItem {
			return !li.hasChildren
		}
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
	
	func expand() {
		getChildItems()
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
	
	func addNodes(_ nodes: [NodeBase]) {
		children = children ?? []
		for node in nodes {
			children!.append(node)
			node.parent = self
		}
		requiresRefresh()
	}
}


