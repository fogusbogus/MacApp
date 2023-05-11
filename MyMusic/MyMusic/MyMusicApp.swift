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
			let artists = Artist.getAll()
			return artists.map({
				let tn = TreeNode()
				tn.data = $0
				return tn
			})
		}
		if let artist = forNode?.data as? Artist {
			return artist.albumsOrdered().map({TreeNode(text: $0.name, data: $0)})
		}
	}
	
	func hasChildren(forNode: TreeView.TreeNode?) -> Bool {
		<#code#>
	}
	
	init() {
		persistenceController.seedData()
	}
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
