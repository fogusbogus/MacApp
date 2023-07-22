//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

protocol NewSubStreetDelegate {
	func cancelNewSubStreet(street: Street?)
	func saveNewSubStreet(street: Street?)
	func cancelEditSubStreet(substreet: SubStreet?)
	func saveEditSubStreet(substreet: SubStreet?)
}

class SubStreetDetails: DataNavigationalDetailsForEditing<SubStreet> {
	
	override func copyObject(object: SubStreet?) {
		self.name = object?.name ?? ""
		self.sortName = object?.sortName ?? ""
		
	}
	
	@Published var name: String = ""
	@Published var sortName: String = ""
	
	override func canSave(withParent: DataNavigational? = nil) -> Bool { !name.isEmptyOrWhitespace() }
	
	override func copyToObject(_ object: SubStreet?) {
		guard let elector = object ?? self.object else { return }
		elector.name = name
		elector.sortName = sortName
	}
	
	override func reset() {
		name = ""
		sortName = ""
	}
}

struct NewSubStreet: View {
	
	var street: Street?
	var delegate: NewSubStreetDelegate?
	
	@StateObject var details = SubStreetDetails()
	
	var warning: String {
		get {
			if details.object == nil {
				return "Not attached to a valid street!"
			}
			
			let ssName = details.object?.objectName.trim() ?? ""
			if ssName.length() == 0 {
				return ""
			}
			
			if street?.getSubStreets().contains(where: {!$0.objectName.implies(details.name)}) ?? false {
				return "Substreet already exists within this street. Use either blank or unique name."
			}
			return ""
		}
	}
	
	func canOK() -> Bool {
		return warning.length() == 0
	}
	
	var substreetEditMode : Bool { details.object != nil }
	
    var body: some View {

		Form {
			Text(substreetEditMode ? "Edit substreet \((details.object?.objectName ?? "").substitute("un-named"))" : "New substreet").font(.largeTitle)
			Text("for \(street?.location ?? details.object?.street?.location ?? "an unknown street")")
			Divider()
			LabeledContent("Polling district:") {
				Text(street?.ward?.pollingDistrict?.objectName ?? details.object?.street?.ward?.pollingDistrict?.objectName ?? "Unknown polling district").bold()
			}
			LabeledContent("Ward:") {
				Text(street?.ward?.objectName ?? details.object?.street?.ward?.objectName ?? "Unknown ward").bold()
			}
			LabeledContent("Street:") {
				Text(street?.objectName ?? details.object?.street?.objectName ?? "Unknown street").bold()
			}
			Divider()
			TextField("Name:", text: $details.name)
			TextField("Sort name:", text: $details.sortName)
			HStack(alignment:.center) {
				if warning != "" {
					Text("⚠️")
					Text(warning)
				}
				Spacer()
				Button {
					if let substreet = details.object {
						details.copyToObject(substreet)
						delegate?.saveEditSubStreet(substreet: substreet)
						delegate?.cancelEditSubStreet(substreet: substreet)
						return
					}
					let ss = SubStreet(context: street!.managedObjectContext ?? PersistenceController.shared.container.viewContext)
					details.copyToObject(ss)
					street!.addToSubStreets(ss)
					details.reset()
					delegate?.saveNewSubStreet(street: street)
					delegate?.cancelNewSubStreet(street: street)
				} label: {
					Text("Save")
				}
				.disabled(!canOK())
				Button {
					if let substreet = details.object {
						delegate?.cancelEditSubStreet(substreet: substreet)
					} else {
						delegate?.cancelNewSubStreet(street: street)
					}
				} label: {
					Text("Cancel")
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}

protocol NewSubStreetDelegateOld {
	func cancelNew(street: Street?)
	func okNew(street: Street?, name: String, sortName: String)
}

struct NewSubStreet_Previews: PreviewProvider {
    static var previews: some View {
        NewSubStreet()
    }
}
