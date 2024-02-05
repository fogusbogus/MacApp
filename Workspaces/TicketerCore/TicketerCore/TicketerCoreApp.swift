//
//  TicketerCoreApp.swift
//  TicketerCore
//
//  Created by Matt Hogg on 12/01/2024.
//

import SwiftUI

@main
struct TicketerCoreApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
