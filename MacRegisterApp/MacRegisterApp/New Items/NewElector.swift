//
//  NewElector.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 11/06/2023.
//

import SwiftUI

protocol NewElectorDelegate {
	func cancelNewElector(property: Abode?)
	func saveNewElector(property: Abode?)
	func cancelEditElector(elector: Elector?)
	func saveEditElector(elector: Elector?)
}



class ElectorDetails: DataNavigationalDetailsForEditing<Elector> {

	override func copyObject(object: Elector?) {
		self.name = object?.name ?? ""
		self.sortName = object?.sortName ?? ""
		self.salutation = object?.salutation ?? ""
		self.email = object?.email ?? ""

	}
	
	@Published var name: String = ""
	@Published var sortName: String = ""
	@Published var salutation: String = ""
	@Published var email: String = ""
	
	override func canSave(withParent: DataNavigational? = nil) -> Bool { !name.isEmptyOrWhitespace() }
	
	override func copyToObject(_ object: Elector?) {
		guard let elector = object ?? self.object else { return }
		elector.name = name
		elector.sortName = sortName
		elector.salutation = salutation
		elector.email = email
	}
		
	override func reset() {
		name = ""
		sortName = ""
		salutation = ""
		email = ""
	}
}

struct NewElector: View {
	var property: Abode? = nil
	var delegate: NewElectorDelegate? = nil
	
	@StateObject var details = ElectorDetails()
	
	func getElectors() -> [Elector] {
		return property?.getElectors() ?? []
	}
	
	var canSave: Bool {
		get {
			if property == nil && details.object == nil {
				return false
			}
			return details.canSave()
		}
	}
	
	var electorEditMode : Bool { details.object != nil }
	
    var body: some View {
		Form {
			Text(electorEditMode ? "Edit elector \(details.object?.objectName ?? "")" : "New elector").font(.largeTitle)
			Text("for \(property?.location ?? details.object?.mainResidence?.location ?? "an unknown address")")
			Divider()
			TextField("Name", text: $details.name)
			TextField("Sort name", text: $details.sortName)
			TextField("Salutation", text: $details.salutation)
			TextField("Email", text: $details.email)
			HStack(alignment: .center, spacing: 16) {
				Spacer()
				Button {
					if let elector = details.object {
						details.copyToObject(elector)
						delegate?.saveEditElector(elector: elector)
						delegate?.cancelEditElector(elector: elector)
						return
					}
					let el = Elector(context: property!.managedObjectContext ?? PersistenceController.shared.container.viewContext)
					details.copyToObject(el)
					property!.addToElectors(el)
					details.reset()
					delegate?.saveNewElector(property: property)
				} label: {
					Text(electorEditMode ? "Save" : "Save/Next")
				}
				.disabled(!canSave)
				Button {
					if let elector = details.object {
						delegate?.cancelEditElector(elector: elector)
					}
					else {
						delegate?.cancelNewElector(property: property)
					}
				} label: {
					Text("Cancel")
				}
			}
			if !electorEditMode {
				Divider()
				Table(getElectors()) {
					TableColumn("Current electors") { el in
						Text(el.objectName)
					}
				}
			}
		}
		.padding()
    }
}

struct NewElector_Previews: PreviewProvider {
    static var previews: some View {
		NewElector(details: ElectorDetails(object:  Elector.getAll().first))
    }
}
