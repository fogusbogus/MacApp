//
//  View+Substreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 02/06/2023.
//

import SwiftUI

class View_SubStreet_Data : ObservableObject {
	
	init(subStreet: SubStreet) {
		self.subStreet = subStreet
		self.name = subStreet.objectName
		self.sortName = subStreet.sortingName
	}
	
	var subStreet: SubStreet {
		didSet {
			reset()
		}
	}
	
	@Published var name: String
	@Published var sortName: String
	
	func save() {
		subStreet.name = name
		subStreet.sortName = sortName
		try? subStreet.managedObjectContext?.save()
	}
	
	func reset() {
		self.name = subStreet.objectName
		self.sortName = subStreet.sortingName
	}
}

extension View_SubStreet_Data {
	var heading: String {
		if !name.isEmptyOrWhitespace() {
			return "Substreet - \(name)"
		}
		return "Unnamed substreet in \(subStreet.street?.objectName ?? "Unknown street")"
	}
}

struct View_SubStreet: View {
	
	init(data: View_SubStreet_Data, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.data = data
		self.delegate = delegate
	}
	
	@ObservedObject var data: View_SubStreet_Data
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			View_Edit_Heading(data.heading, delegate: self)
			Divider()
			Form {
				Section {
					LabeledContent("Polling district", value: data.subStreet.street?.ward?.pollingDistrict?.name ?? "Unknown")
					LabeledContent("Ward", value: data.subStreet.street?.ward?.name ?? "Unknown")
					LabeledContent("Street", value: data.subStreet.street?.name ?? "Unknown")
					LabeledContent("Properties", value: "\(data.subStreet.propertyCount)")
					LabeledContent("Electors", value: "\(data.subStreet.electorCount)")
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

extension View_SubStreet : View_Edit_Heading_Delegate {
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
		return data.subStreet.propertyCount == 0
	}
	
	func inEditMode() -> Bool {
		return editMode
	}
}

struct View_Substreet_Previews: PreviewProvider {
    static var previews: some View {
		View_SubStreet(data: View_SubStreet_Data(subStreet: SubStreet.getAll().first!))
    }
}
