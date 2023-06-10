//
//  View+Ward.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI


class View_Ward_Data : ObservableObject {
	
	init(ward: Ward) {
		self.ward = ward
		self.name = ward.objectName
		self.sortName = ward.sortingName
	}
	
	var ward: Ward {
		didSet {
			reset()
		}
	}
	
	@Published var name: String
	@Published var sortName: String
	
	func save() {
		ward.name = name
		ward.sortName = sortName
		try? ward.managedObjectContext?.save()
	}
	
	func reset() {
		self.name = ward.objectName
		self.sortName = ward.sortingName
	}
}

struct View_Ward: View {
	
	init(data: View_Ward_Data, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.data = data
		self.delegate = delegate
	}
	
	@ObservedObject var data: View_Ward_Data
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			View_Edit_Heading("Ward - \(data.name)", delegate: self)
			Divider()
			Form {
				Section {
					LabeledContent("Polling district", value: data.ward.pollingDistrict?.name ?? "Unknown")
					LabeledContent("Streets", value: "\(data.ward.streetCount)")
					LabeledContent("Substreets", value: "\(data.ward.subStreetCount)")
					LabeledContent("Properties", value: "\(data.ward.propertyCount)")
					LabeledContent("Electors", value: "\(data.ward.electorCount)")
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

extension View_Ward : View_Edit_Heading_Delegate {
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
		return data.ward.streetCount == 0
	}
	
	func inEditMode() -> Bool {
		return editMode
	}
}

struct View_Ward_Previews: PreviewProvider {
	static var previews: some View {
		View_Ward(data: View_Ward_Data(ward: Ward.getAll().first!))
	}
}
