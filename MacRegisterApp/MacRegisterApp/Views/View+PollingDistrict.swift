//
//  View+PollingDistrict.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI
import MeasuringView

class SubLog: MeasuringViewLogging {
	
	init() {
		Log.devMode = true
	}
	func log(_ type: String, _ message: String) {
		switch type {
			case "D":
				Log.log(message)
				
			case "F":
				Log.log(Log.label(message))
				
			default:
				Log.log(message)
		}
	}
	
	
}

protocol UpdateDataNavigationalDelegate {
	func update(item: DataNavigational?)
}

class View_PollingDistrict_Data : ObservableObject {
	
	init(pollingDistrict: PollingDistrict) {
		self.pollingDistrict = pollingDistrict
		self.name = pollingDistrict.objectName
		self.sortName = pollingDistrict.sortingName
	}
	
	var pollingDistrict: PollingDistrict {
		didSet {
			reset()
		}
	}
	
	@Published var name: String
	@Published var sortName: String
	
	func save() {
		pollingDistrict.name = name
		pollingDistrict.sortName = sortName
		try? pollingDistrict.managedObjectContext?.save()
	}
	
	func reset() {
		self.name = pollingDistrict.objectName
		self.sortName = pollingDistrict.sortingName
	}
}

struct View_PollingDistrict: View {
	
	init(data: View_PollingDistrict_Data, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.data = data
		self.delegate = delegate
	}
	
	@ObservedObject var data: View_PollingDistrict_Data
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			View_Edit_Heading("Polling district - \(data.name)", delegate: self)
			Divider()
			Form {
				Section {
					LabeledContent("Wards", value: "\(data.pollingDistrict.wardCount)")
					LabeledContent("Streets", value: "\(data.pollingDistrict.streetCount)")
					LabeledContent("Substreets", value: "\(data.pollingDistrict.subStreetCount)")
					LabeledContent("Properties", value: "\(data.pollingDistrict.propertyCount)")
					LabeledContent("Electors", value: "\(data.pollingDistrict.electorCount)")
				}
				Divider()
				Section {
					TextField("Name", text: $data.name)
						.disabled(!editMode)
					TextField("Sort name", text: $data.sortName)
						.disabled(!editMode)
				}
//				Spacer().frame(height:16)
//				HStack(alignment: .firstTextBaseline) {
//					Spacer()
//					if editMode {
//						Button {
//							editMode = false
//							data.save()
//							delegate?.update(item: data.pollingDistrict)
//						} label: {
//							Text("OK")
//						}
//						Button {
//							editMode = false
//							data.reset()
//						} label: {
//							Text("Cancel")
//						}
//					}
//					else {
//						Button {
//							editMode = true
//						} label: {
//							Text("Edit")
//						}
//					}
//				}
			}
		}
		.padding()
	}
}

extension View_PollingDistrict : View_Edit_Heading_Delegate {
	func edit() {
		editMode = true
	}
	
	func delete() {
		//TODO: Mark as deleted
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
		return data.pollingDistrict.wardCount == 0
	}
	
	func inEditMode() -> Bool {
		return self.editMode
	}
	
	
}


struct View_PollingDistrict_Previews: PreviewProvider {
	static var previews: some View {
		View_PollingDistrict(data: View_PollingDistrict_Data(pollingDistrict: PollingDistrict.getAll().first!))
	}
}
