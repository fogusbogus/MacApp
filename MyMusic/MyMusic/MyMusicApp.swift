//
//  MyMusicApp.swift
//  MyMusic
//
//  Created by Matt Hogg on 09/05/2023.
//

import SwiftUI
import TreeView

@main
struct MyMusicApp: App, TreeNodeDataProvider {
	func getChildren(forNode: TreeNode?) -> [TreeNode] {
		guard forNode != nil else {
			return Artist.getAll().filter({$0.hasAlbums()}).map({TreeNode(text: $0.name ?? "", data: $0)})
		}
		if let artist = forNode?.data as? Artist {
			return artist.albumsOrdered().map({TreeNode(text: $0.name ?? "", data: $0)})
		}
		if let album = forNode?.data as? Album {
			return album.tracksOrdered().map({TreeNode(text: $0.name ?? "", data: $0)})
		}
		return []
	}
	
	func hasChildren(forNode: TreeNode?) -> Bool {
		guard let forNode = forNode else {
			return Artist.getAll().count > 0
		}
		if let artist = forNode.data as? Artist {
			return artist.albumsPerformedOn?.allObjects.count ?? 0 > 0
		}
		if let album = forNode.data as? Album {
			return album.tracks?.allObjects.count ?? 0 > 0
		}
		
		return false
	}
	
	init() {
		persistenceController.seedData()
	}
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
			ScrollView {
				TreeViewUI(options: TreeViewUIOptions(), dataProvider: self)
					.environment(\.managedObjectContext, persistenceController.container.viewContext)
			}
        }
    }
}
