//
//  blahApp.swift
//  blah
//
//  Created by Matt Hogg on 12/09/2021.
//

import SwiftUI

@main
struct blahApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
