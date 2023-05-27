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
	internal init(options: TreeViewUIOptions = TreeViewUIOptions(), updater: Updater = Updater(), treeView: TreeView? = nil, dataProvider: TreeNodeDataProvider? = nil, contextMenuDelegate: TreeNodeContextMenuProvider? = nil) {
		self.options = options
		self.updater = updater
		self.treeView = treeView ?? TreeView()
		self.treeView?.dataProviderDelegate = dataProvider
		self.dataProvider = dataProvider
		self.treeView?.dataProviderDelegate = dataProvider
		self.contextMenuDelegate = contextMenuDelegate
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
				.background(selected ? Color.green : Color.clear)
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
				.background(selected ? Color.green : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})
	}
}

struct TreeNodeStreet: View {
	var node: TreeNode
	var selected: Bool
	var contextMenuDelegate: TreeNodeContextMenuProvider?

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
				.background(selected ? Color.green : Color.clear)
		}
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
				if abodeCount != 1 {
					return "\(abodeCount) properties"
				}
				return "1 property"
			}
			return "<Unknown>"
		}
	}
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text("📍")
			Text(name)
				.background(selected ? Color.green : Color.clear)
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
				.background(selected ? Color.green : Color.clear)
		}
		.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(node: node)})
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
					.onTapGesture {
						delegate?.select(node: node)
					}
			}
			if let wd = node.data as? Ward {
				TreeNodeWard(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.onTapGesture {
						delegate?.select(node: node)
					}
			}
			if let st = node.data as? Street {
				TreeNodeStreet(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.onTapGesture {
						delegate?.select(node: node)
					}
			}
			if let ss = node.data as? SubStreet {
				TreeNodeSubStreet(node: node, selected: selected, contextMenuDelegate: contextMenuDelegate)
					.onTapGesture {
						delegate?.select(node: node)
					}
			}
			Spacer()
				.onTapGesture {
					delegate?.select(node: nil)
				}
		}
		
	}
}

protocol TreeNodeContextMenuProvider {
	func getContextMenu(node: TreeNode) -> AnyView
}
