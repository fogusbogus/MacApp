//
//  View+Ward.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI
import MeasuringView


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
		self.measure = MeasuringView(delegate: SubLog())
	}
	
	@ObservedObject var data: View_Ward_Data
	
	@ObservedObject var measure = MeasuringView(delegate: SubLog())
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Heading("🎗️ - \(data.name)")
			Divider()
			Group {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Ward")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text(data.ward.pollingDistrict?.name ?? "Unknown")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Streets")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(data.ward.getStreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Substreets")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(data.ward.getSubstreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Properties")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(data.ward.getAbodes().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Electors")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(data.ward.getElectors().count ?? 0)")
				}
			}
			Divider()
			Group {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Name")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					TextField("Ward name", text: $data.name)
						.disabled(!editMode)
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Sort name")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					TextField("Ward sort name", text: $data.sortName)
						.disabled(!editMode)
				}
				HStack(alignment: .firstTextBaseline) {
					Spacer()
					if editMode {
						Button {
							editMode = false
							data.save()
							//delegate?.update(item: ward)
						} label: {
							Text("OK")
						}
						Button {
							editMode = false
							data.reset()
//							data.name = ward?.name ?? ""
//							data.sortName = ward?.sortName ?? ""
						} label: {
							Text("Cancel")
						}
					}
					else {
						Button {
							editMode = true
						} label: {
							Text("Edit")
						}
					}
				}
			}
		}
		.padding()
		.onAppear {
			//initiate()
			Log.log(measure.dump())
		}
	}
}

struct View_Ward_Previews: PreviewProvider {
	static var previews: some View {
		View_Ward(data: View_Ward_Data(ward: Ward.getAll().first!))
	}
}
