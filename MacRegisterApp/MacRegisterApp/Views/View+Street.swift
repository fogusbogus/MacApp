//
//  View+Street.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 02/06/2023.
//

import SwiftUI

class View_Street_Data : ObservableObject {
	
	init(street: Street) {
		self.street = street
		self.name = street.objectName
		self.sortName = street.sortingName
	}
	
	var street: Street {
		didSet {
			reset()
		}
	}
	
	@Published var name: String
	@Published var sortName: String
	
	func save() {
		street.name = name
		street.sortName = sortName
		try? street.managedObjectContext?.save()
	}
	
	func reset() {
		self.name = street.objectName
		self.sortName = street.sortingName
	}
}

extension View_Street_Data {
	var heading: String {
		if !name.isEmptyOrWhitespace() {
			return "Street - \(name)"
		}
		return "Unnamed street in \(street.ward?.objectName ?? "Unknown ward")"
	}
}

struct View_Street: View {
	
	init(data: View_Street_Data, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.data = data
		self.delegate = delegate
	}
	
	@ObservedObject var data: View_Street_Data
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			View_Edit_Heading(data.heading, delegate: self)
			Divider()
			Form {
				Section {
					LabeledContent("Polling district", value: data.street.ward?.pollingDistrict?.name ?? "Unknown")
					LabeledContent("Ward", value: data.street.ward?.name ?? "Unknown")
					LabeledContent("Substreets", value: "\(data.street.subStreetCount)")
					LabeledContent("Properties", value: "\(data.street.propertyCount)")
					LabeledContent("Electors", value: "\(data.street.electorCount)")
				}
				Divider()
				Section {
					TextField("Name", text: $data.name)
						.disabled(!editMode)
					TextField("Sort name", text: $data.sortName)
						.disabled(!editMode)
				}
			}
		}
		.padding()
	}
}

extension View_Street : View_Edit_Heading_Delegate {
	func edit() {
		editMode = true
	}
	
	func delete() {
		//TODO: Implement
	}
	
	func save() {
		data.save()
		editMode = false
	}
	
	func cancel() {
		editMode = false
		data.reset()
	}
	
	func canEdit() -> Bool {
		return true
	}
	
	func canDelete() -> Bool {
		return data.street.subStreetCount == 0
	}
	
	func inEditMode() -> Bool {
		return editMode
	}
}

struct View_Street_Previews: PreviewProvider {
	static var previews: some View {
		View_Street(data: View_Street_Data(street: Street.getAll().first!))
	}
}
