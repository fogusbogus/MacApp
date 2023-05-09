//
//  ContentView.swift
//  TreeViewDep
//
//  Created by Matt Hogg on 24/04/2023.
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
	internal init(options: TreeViewUIOptions = TreeViewUIOptions(), updater: Updater = Updater(), treeView: TreeView? = nil, dataProvider: TreeNodeDataProvider? = nil) {
		self.options = options
		self.updater = updater
		self.treeView = treeView
		self.dataProvider = dataProvider
		self.treeView?.dataProviderDelegate = dataProvider
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
	
	var body: some View {
		VStack(alignment: .leading) {
			ForEach(treeView?.getVisibleNodes() ?? [], id:\.self) { node in
				VisibleNode(node: node, delegate: self, options: options, dataProvider: dataProvider)
			}
		}
		.padding()
	}
}

//protocol TreeViewNotifier {
//	func selectionChanged(node: TreeNode?, data: AnyObject?)
//}

struct AlbumNodeUI : View {
	var node: AlbumNode
	var selected: Bool
	var body: some View {
		Text(node.text)
			.background(selected ? .gray : .clear)
			.font(Font.system(.body).smallCaps())
	}
}

struct ArtistNodeUI: View {
	var node: ArtistNode
	var selected: Bool
	var body: some View {
		Text(node.text.uppercased()).bold()
			.background(selected ? .gray : .clear)
	}
}

struct TrackNodeUI: View {
	var node: TrackNode
	var selected: Bool
	var body: some View {
		Text(node.text).foregroundColor(Color.blue)
			.background(selected ? .gray : .clear)
	}
}

struct InfoNodeUI: View {
	var node: TreeNode
	var selected: Bool
	var body: some View {
		Text(node.text).foregroundColor(Color.gray)
			.italic()
			.border(.red, width: 1)
			.padding([.top, .bottom])
	}
}

struct VisibleNode: View {
	internal init(node: TreeNode, delegate: TreeViewUIDelegate? = nil, options: TreeViewUIOptions = TreeViewUIOptions(), dataProvider: TreeNodeDataProvider? = nil) {
		self.node = node
		self.delegate = delegate
		self.options = options
		self.node.dataProviderDelegate = dataProvider
		self.dataProvider = dataProvider
	}
	
	
	var node: TreeNode
	var delegate: TreeViewUIDelegate?
	var options: TreeViewUIOptions = TreeViewUIOptions()
	var dataProvider: TreeNodeDataProvider?
	
	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			Text(!node.hasChildren ? "" : (node.expanded ? options.expandedSymbol : options.collapsedSymbol))
				.frame(width:CGFloat(options.indentSize) * CGFloat(node.level + 1))
				.onTapGesture {
					node.expanded = !node.expanded
					delegate?.update()
				}
			let selected = node.treeView?.getSelectedNode() == node
			if let album = node as? AlbumNode {
				AlbumNodeUI(node: album, selected: selected)
					.onTapGesture {
						delegate?.select(node: node)
					}
			} else
			if let artist = node as? ArtistNode {
				ArtistNodeUI(node: artist, selected: selected)
					.onTapGesture {
						delegate?.select(node: node)
					}
			} else
			if let track = node as? TrackNode {
				TrackNodeUI(node: track, selected: selected)
					.onTapGesture {
						delegate?.select(node: node)
					}
			} else {
				InfoNodeUI(node: node, selected: selected)
			}
			Spacer()
				.onTapGesture {
					delegate?.select(node: nil)
				}
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
	
	static func getTreeView() -> TreeView {
		let ret = TreeView()
		let first = ret.append(text: "First")
		first.append(text: "First.First")
		first.append(text: "First.Second")
		ret.append(text: "Second")
		return ret
	}
	
	static var previews: some View {
		TreeViewUI(treeView: getTreeView())
	}
}