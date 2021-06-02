//
//  CoreDataTestApp.swift
//  CoreDataTest
//
//  Created by Matt Hogg on 11/01/2021.
//

import SwiftUI

@main
struct CoreDataTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
