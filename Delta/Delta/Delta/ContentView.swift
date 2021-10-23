//
//  ContentView.swift
//  Delta
//
//  Created by Matt Hogg on 30/09/2021.
//

import SwiftUI
import CoreData
import Delta_Visit

struct ContentView: View {
	var body: some View {
		Comment_DataEntry()
			.padding()
	}
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
