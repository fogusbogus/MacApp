//
//  MyMusicApp.swift
//  MyMusic
//
//  Created by Matt Hogg on 09/05/2023.
//

import SwiftUI

@main
struct MyMusicApp: App {
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
