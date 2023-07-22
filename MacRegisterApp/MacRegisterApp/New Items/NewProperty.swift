//
//  NewProperty.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 14/06/2023.
//

import SwiftUI

class PropertyDetails : DataNavigationalDetailsForEditing<Abode> {
	
	@Published var name: String = ""
	@Published var sortName: String = ""
	@Published var email: String = ""
	@Published var type: String = ""
	@Published var future: Bool = false
	
	override func copyObject(object: Abode?) {
		self.name = object?.name ?? ""
		self.sortName = object?.sortName ?? ""
		self.email = object?.email ?? ""
		self.type = object?.type ?? ""
		self.future = object?.future ?? false
	}
	
	override func canSave(withParent: DataNavigational? = nil) -> Bool {
		if name.isEmptyOrWhitespace() {
			return false
		}
		if let subStreet = withParent as? SubStreet ?? object?.subStreet {
			if subStreet.getAbodes().contains(where: {$0.objectName.removeMultipleSpaces(true).implies(name.removeMultipleSpaces(true)) && $0.id != object?.id}) {
				return false
			}
		}
		return true
	}
	
	override func copyToObject(_ object: Abode?) {
		guard let abode = object ?? self.object else { return }
		abode.name = name
		abode.sortName = sortName
		abode.email = email
		abode.type = type
		abode.future = future
	}
	
	override func reset() {
		name = ""
		sortName = ""
		email = ""
		type = ""
		future = false
	}
}

struct FormToggle : View {
	
	var label: String
	var isOn: Binding<Bool>
	
	var body: some View {
		LabeledContent(label) {
			Toggle("", isOn: isOn)
				.offset(y: -5)
		}
	}
}

protocol NewPropertyDelegate {
	func cancelEditProperty(property: Abode?)
	func saveEditProperty(property: Abode?)
	func cancelNewProperty(subStreet: SubStreet?)
	func saveNewProperty(subStreet: SubStreet?)
}

struct NewProperty: View {
	var subStreet: SubStreet? = nil
	var delegate: NewPropertyDelegate? = nil
	
	@StateObject var details = PropertyDetails()
	
	func getProperties() -> [Abode] {
		return subStreet?.getAbodes() ?? []
	}
	
	var canSave: Bool {
		get {
			if subStreet == nil && details.object == nil {
				return false
			}
			return details.canSave()
		}
	}
	
	var propertyEditMode : Bool { details.object != nil }
	
	var body: some View {
		Form {
			Text(propertyEditMode ? "Edit property \(details.object?.objectName ?? "")" : "New property").font(.largeTitle)
			Text("for \(subStreet?.location ?? details.object?.subStreet?.location ?? "an unknown substreet")")
			Divider()
			TextField("Name", text: $details.name)
			TextField("Sort name", text: $details.sortName)
			TextField("Email", text: $details.email)
			TextField("Type", text: $details.type)
			FormToggle(label: "Future:", isOn: $details.future)

			HStack(alignment: .center, spacing: 16) {
				Spacer()
				Button {
					if let property = details.object {
						details.copyToObject(property)
						delegate?.saveEditProperty(property: property)
						delegate?.cancelEditProperty(property: property)
						return
					}
					let pr = Abode(context: subStreet!.managedObjectContext ?? PersistenceController.shared.container.viewContext)
					details.copyToObject(pr)
					subStreet!.addToAbodes(pr)
					details.reset()
					delegate?.saveNewProperty(subStreet: subStreet)
				} label: {
					Text(propertyEditMode ? "Save" : "Save/Next")
				}
				.disabled(!canSave)
				Button {
					if let property = details.object {
						delegate?.cancelEditProperty(property: property)
					}
					else {
						delegate?.cancelNewProperty(subStreet: subStreet)
					}
				} label: {
					Text("Cancel")
				}
			}
			if !propertyEditMode {
				Divider()
				Table(getProperties()) {
					TableColumn("Current properties") { pr in
						Text(pr.objectName)
					}
				}
			}
		}
		.padding()
	}
}


struct NewProperty_Previews: PreviewProvider {
	static var previews: some View {
		NewProperty(details: PropertyDetails(object:  Abode.getAll().first))
	}
}
