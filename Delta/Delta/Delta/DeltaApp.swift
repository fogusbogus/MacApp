//
//  DeltaApp.swift
//  Delta
//
//  Created by Matt Hogg on 30/09/2021.
//

import SwiftUI
import Delta_Visit

@main
struct DeltaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
			Delta_Visit.Attachment_Add()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
