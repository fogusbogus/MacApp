//
//  NewElector.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 11/06/2023.
//

import SwiftUI

protocol NewElectorDelegate {
	func cancel(property: Abode?)
	func save(property: Abode?)
}

struct NewElector: View {
	var property: Abode? = nil
	var delegate: NewElectorDelegate? = nil
	
	@State var name: String = ""
	@State var sortName: String = ""
	
	func getElectors() -> [Elector] {
		return property?.getElectors() ?? []
	}
	
    var body: some View {
		Form {
			Text("New elector").font(.largeTitle)
			Text("for \(property?.location ?? "an unknown address")")
			Divider()
			TextField("Name", text: $name)
			TextField("Sort name", text: $sortName)
			HStack(alignment: .center, spacing: 16) {
				Spacer()
				Button {
					var el = Elector(context: property!.managedObjectContext ?? PersistenceController.shared.container.viewContext)
					el.name = name
					el.sortName = sortName
					property!.addToElectors(el)
					name = ""
					sortName = ""
					delegate?.save(property: property)
				} label: {
					Text("Save/Next")
				}
				.disabled(name.isEmptyOrWhitespace() || property == nil)
				Button {
					delegate?.cancel(property: property)
				} label: {
					Text("Cancel")
				}
			}
			Divider()
			Table(getElectors()) {
				TableColumn("Current electors") { el in
					Text(el.objectName)
				}
			}
		}
    }
}

struct NewElector_Previews: PreviewProvider {
    static var previews: some View {
        NewElector()
    }
}
