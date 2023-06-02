//
//  View+Ward.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI
import MeasuringView


struct View_Ward_Data {
	var name: String = ""
	var sortName: String = ""
}

struct View_Ward: View {
	
	init(ward: Ward? = nil, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.ward = ward
		self.delegate = delegate
		self.data = View_Ward_Data(name: ward?.name ?? "", sortName: ward?.sortName ?? "")
	}
	
	func save() {
		if let save = ward {
			save.name = data.name
			save.sortName = data.sortName
			try? save.managedObjectContext?.save()
		}
	}
	
	var ward: Ward?
	
	@ObservedObject var measure = MeasuringView()
	
	@State private var data = View_Ward_Data()
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	@State private var initiated = false
	
	private func initiate() {
		initiated = true
		data.name = ward?.name ?? data.name
		data.sortName = ward?.sortName ?? data.sortName
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Heading("🇬🇧 - \(ward?.name ?? "<Unknown Ward>")")
			Divider()
			Group {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Ward")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text(ward?.pollingDistrict?.name ?? "Unknown")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Streets")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(ward?.getStreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Substreets")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(ward?.getSubstreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Properties")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(ward?.getAbodes().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Electors")
						.decidesWidthOf(measure, key: "WARDPROMPT", alignment: .trailing)
					Text("\(ward?.getElectors().count ?? 0)")
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
							save()
							delegate?.update(item: ward)
						} label: {
							Text("OK")
						}
						Button {
							editMode = false
							data.name = ward?.name ?? ""
							data.sortName = ward?.sortName ?? ""
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
			initiate()
		}
	}
}

struct View_Ward_Previews: PreviewProvider {
	static var previews: some View {
		View_Ward()
	}
}
