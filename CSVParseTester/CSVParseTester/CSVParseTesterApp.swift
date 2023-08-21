//
//  CSVParseTesterApp.swift
//  CSVParseTester
//
//  Created by Matt Hogg on 04/08/2023.
//

import SwiftUI

@main
struct CSVParseTesterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
