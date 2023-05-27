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
		self.treeView = treeView ?? TreeView()
		self.treeView?.dataProviderDelegate = dataProvider
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
	var node: Album
	var selected: Bool
	
	var title: String {
		get {
			return (node.name ?? "") + " (\(node.releaseYear))"
		}
	}
	var body: some View {
		Text(title)
			.background(selected ? .gray : .clear)
			.font(Font.system(.body).smallCaps())
	}
}

struct ArtistNodeUI: View {
	var node: Artist
	var selected: Bool
	var body: some View {
		Text(node.name!.uppercased()).bold()
			.background(selected ? .gray : .clear)
	}
}

extension Array where Element == Artist {
	func sameContent(_ other: Array<Element>) -> Bool {
		if self.count != other.count {
			return false
		}
		let selfSorted = self.sorted { a, b in
			return a.name! < b.name!
		}
		let otherSorted = other.sorted { a, b in
			return a.name! < b.name!
		}
		return selfSorted.elementsEqual(otherSorted)
	}
}

extension Track {
	func musicBy() -> [Artist] {
		return self.authors?.array.map { $0 as! Artist } ?? []
	}
	
	func lyricsBy() -> [Artist] {
		return self.lyricists?.array.map { $0 as! Artist } ?? []
	}
	
}

struct TrackNodeUI: View {
	var node: Track
	var selected: Bool
	
	var title: String {
		get {
			var ret = node.name ?? "Unknown Track"
			return ret
		}
	}
	
	func describeArtists(artists: [Artist]) -> String {
		var who: [String] = []
		artists.forEach { artist in
			var lastName = artist.lastName()
			if artists.filter({$0.lastName() == lastName}).count > 1 {
				lastName = artist.lastNameAndInitials()
			}
			who.append(lastName)
		}
		return who.joined(separator: "/")
	}
	
	/// Get the authors in a descriptive string
	/// e.g.
	/// M: Banks/Collins/Rutherford L: Collins
	/// or
	/// Banks/Collins/Rutherford (no lyrics or if music and lyrics by same people regardless of order)
	var authors: String {
		get {
			let music = node.musicBy()
			let lyrics = node.lyricsBy()
			
			let showMusic = music.count > 0
			var showLyrics = lyrics.count > 0
			
			if music.sameContent(lyrics) {
				showLyrics = false
			}
			
			if showLyrics {
				let musicSurnames = describeArtists(artists: music)
				let lyricSurnames = describeArtists(artists: lyrics)
				
				
				return " (M: \(musicSurnames) L: \(lyricSurnames))"
			}
			if showMusic {
				let musicSurnames = describeArtists(artists: music)
				return " (" + musicSurnames + ")"
			}
			return ""
		}
	}
	
	var body: some View {
		Group {
			HStack(alignment: .center, spacing: 0) {
				Text(title).foregroundColor(Color.blue).background(selected ? .gray : .clear)
				Text(" \(authors)").italic().foregroundColor(.gray)
			}
		}
	}
}

extension Artist {
	func lastName() -> String {
		return self.name?.splitToArray(" ").last ?? ""
	}
	
	func lastNameAndInitials() -> String {
		return self.name ?? ""
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
			if let album = node.data as? Album {
				AlbumNodeUI(node: album, selected: selected)
					.onTapGesture {
						delegate?.select(node: node)
					}
			} else
			if let artist = node.data as? Artist {
				ArtistNodeUI(node: artist, selected: selected)
					.onTapGesture {
						delegate?.select(node: node)
					}
			} else
			if let track = node.data as? Track {
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

