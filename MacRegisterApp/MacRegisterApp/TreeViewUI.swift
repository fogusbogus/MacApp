//
//  TreeViewUI.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import TreeView

class Updater : ObservableObject {
	@Published var toggle : Bool = false
}

class TreeViewUIOptions {
	var expandedSymbol: String = "▼"
	var collapsedSymbol: String = "▶"
	var indentSize: Int = 24
}

struct TreeViewUI: View, TreeViewUIDelegate {
	internal init(options: TreeViewUIOptions = TreeViewUIOptions(), updater: Updater = Updater(), treeView: TreeView? = nil, dataProvider: TreeNodeDataProvider? = nil, contextMenuDelegate: TreeNodeContextMenuProvider? = nil, treeViewUIDelegate: TreeViewUIDelegate? = nil) {
		self.options = options
		self.updater = updater
		self.treeView = treeView ?? TreeView()
		self.treeView?.dataProviderDelegate = dataProvider
		self.dataProvider = dataProvider
		self.treeView?.dataProviderDelegate = dataProvider
		self.contextMenuDelegate = contextMenuDelegate
		self.treeViewUIDelegate = treeViewUIDelegate
	}
	
	func update() {
		updater.toggle = !updater.toggle
	}
	
	func select(node: TreeNode?) {
		if let node = node {
			if !node.selectable {
				return
			}
		}
		treeView?.selectedNode = node
		update()
		treeViewUIDelegate?.select(node: node)
	}
	
	var options: TreeViewUIOptions = TreeViewUIOptions()
	
	@ObservedObject var updater: Updater = Updater()
	
	var treeView: TreeView?
	
	var dataProvider: TreeNodeDataProvider?
	
	var contextMenuDelegate: TreeNodeContextMenuProvider?
	
	var visibleNodes: [TreeNode] {
		get {
			let ret = treeView?.getVisibleNodes().map({ tn in
				tn.treeView = self.treeView
				return tn
			})
			return ret ?? []
		}
	}
	
	var treeViewUIDelegate: TreeViewUIDelegate?
	
	func gotoNodeFor(item: DataNavigational) {
		let el : Elector? = item as? Elector
		let pr : Abode? = el?.mainResidence ?? item as? Abode
		let ss : SubStreet? = pr?.subStreet ?? item as? SubStreet
		let st : Street? = ss?.street ?? item as? Street
		let wd : Ward? = st?.ward ?? item as? Ward
		let pd : PollingDistrict? = wd?.pollingDistrict ?? item as? PollingDistrict

		treeView?.findNode(data: pd)?.expanded = wd != nil
		treeView?.findNode(data: wd)?.expanded = st != nil
		treeView?.findNode(data: st)?.expanded = ss != nil
		if let nodeToSelect = treeView?.findNode(data: ss) ?? treeView?.findNode(data: st) ?? treeView?.findNode(data: wd) ?? treeView?.findNode(data: pd) {
			treeView?.selectedNode = treeView?.findNode(node: nodeToSelect)
		}
		
	}

	var body: some View {
		VStack(alignment: .leading) {
			ForEach(visibleNodes, id:\.self) { node in
				VisibleNode(node: node, delegate: self, options: options, dataProvider: dataProvider, contextMenuDelegate: contextMenuDelegate)
			}
		}
		.padding()
	}
}



struct TreeNodePollingDistrict: View {
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?
	
	var name: String {
		get {
			if let pd = node.data as? PollingDistrict {
				return pd.name ?? "<Unknown Polling District>"
			}
			return "<Unknown Polling District>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("🇬🇧")
			Text(name)
				.background(selected ? Color.blue : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})

	}
}

struct TreeNodeWard: View {
	
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?

	var name: String {
		get {
			if let wd = node.data as? Ward {
				return wd.name ?? "<Unknown Ward>"
			}
			return "<Unknown Ward>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("🎗️")
			Text(name)
				.background(selected ? Color.blue : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})
	}
}

struct TreeNodeStreet: View {
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?
	
	@State var isTargeted: Bool = false

	var name: String {
		get {
			if let st = node.data as? Street {
				return st.name ?? "<Unknown Street>"
			}
			return "<Unknown>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("🏘️")
			Text(name)
				.background(selected ? Color.blue : Color.clear)
		}
		.background(isTargeted ? Color(nsColor: .highlightColor) : Color(nsColor: .controlBackgroundColor))
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})

	}
}

struct TreeNodeSubStreet: View {
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?

	var name: String {
		get {
			if let ss = node.data as? SubStreet {
				let abodeCount = ss.abodes?.count ?? 0
				var ssName = ss.name ?? ""
				if !ssName.isEmptyOrWhitespace() {
					ssName = " (\(ssName))"
				}
				if abodeCount != 1 {
					return "\(abodeCount) properties\(ssName)"
				}
				return "1 property\(ssName)"
			}
			return "<Unknown>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("📍")
			Text(name)
				.background(selected ? Color.blue : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})
	}
}

struct TreeNodeAbode: View {
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?

	var name: String {
		get {
			if let pr = node.data as? Abode {
				return pr.name ?? "<Unknown Property>"
			}
			return "<Unknown Property>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("🛖")
			Text(name)
				.background(selected ? Color.blue : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})
	}
}

extension TreeNode {
	func getTransferableObject() -> NavDataIdentifier {
		if let data = self.data as? DataNavigational {
			print("getTransferableObject()")
			return NavDataIdentifier.from(object: data)
		}
		return NavDataIdentifier.from(object: nil)
	}
}

struct VisibleNode: View {
	internal init(node: TreeNode, delegate: TreeViewUIDelegate? = nil, options: TreeViewUIOptions = TreeViewUIOptions(), dataProvider: TreeNodeDataProvider? = nil, contextMenuDelegate: TreeNodeContextMenuProvider? = nil) {
		self.node = node
		self.delegate = delegate
		self.options = options
		self.node.dataProviderDelegate = dataProvider
		self.dataProvider = dataProvider
		self.contextMenuDelegate = contextMenuDelegate
	}
	
	
	var node: TreeNode
	var delegate: TreeViewUIDelegate?
	var options: TreeViewUIOptions = TreeViewUIOptions()
	var dataProvider: TreeNodeDataProvider?
	var contextMenuDelegate: TreeNodeContextMenuProvider?
	
	@State var isTargeted: Bool = false
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text(!node.hasChildren ? "" : (node.expanded ? options.expandedSymbol : options.collapsedSymbol))
				.frame(width:CGFloat(options.indentSize) * CGFloat(node.level + 1))
				.onTapGesture {
					node.expanded = !node.expanded
					delegate?.update()
				}
			let selected = node.treeView?.getSelectedNode() == node
			if let pd = node.data as? PollingDistrict {
				TreeNodePollingDistrict(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.draggable(node.getTransferableObject())
					.onTapGesture {
						delegate?.select(node: node)
					}
			}
			if let wd = node.data as? Ward {
				TreeNodeWard(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.draggable(node.getTransferableObject())
					.onTapGesture {
						delegate?.select(node: node)
					}

			}
			if let st = node.data as? Street {
				TreeNodeStreet(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.draggable(node.getTransferableObject())
					.onTapGesture {
						delegate?.select(node: node)
					}
				
			}
			if let ss = node.data as? SubStreet {
				TreeNodeSubStreet(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.draggable(NavDataIdentifier(type: "SubStreet", objectID: String(describing: ss.objectID)))
					.onTapGesture {
						delegate?.select(node: node)
					}

			}
			Spacer()
				.onTapGesture {
					delegate?.select(node: nil)
				}
		}
		.background(isTargeted ? Color.orange : Color.clear)
		.dropDestination(for: NavDataIdentifier.self) { items, location in
			items.forEach { nav in
				print(nav.type)
			}
			return true
		} isTargeted: { value in
			self.isTargeted = true
		}

		
	}
}

protocol TreeNodeContextMenuProvider {
	func getContextMenu(node: TreeNode) -> AnyView
}
