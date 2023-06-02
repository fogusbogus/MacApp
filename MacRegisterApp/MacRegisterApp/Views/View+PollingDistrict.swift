//
//  View+PollingDistrict.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI
import MeasuringView

protocol UpdateDataNavigationalDelegate {
	func update(item: DataNavigational?)
}

struct View_PollingDistrict_Data {
	var name: String = ""
	var sortName: String = ""
}

struct View_PollingDistrict: View {
	
	init(pollingDistrict: PollingDistrict? = nil, delegate: UpdateDataNavigationalDelegate? = nil) {
		self.pollingDistrict = pollingDistrict
		self.delegate = delegate
		self.data = View_PollingDistrict_Data(name: pollingDistrict?.name ?? "", sortName: pollingDistrict?.sortName ?? "")
	}
	
	func save() {
		if let save = pollingDistrict {
			save.name = data.name
			save.sortName = data.sortName
			try? save.managedObjectContext?.save()
		}
	}
	
	var pollingDistrict: PollingDistrict?
	
	@ObservedObject var measure = MeasuringView()
	
	@State private var data = View_PollingDistrict_Data()
	
	@State private var editMode = false
	
	var delegate: UpdateDataNavigationalDelegate? = nil
	
	@State private var initiated = false
	
	private func initiate() {
		initiated = true
		data.name = pollingDistrict?.name ?? data.name
		data.sortName = pollingDistrict?.sortName ?? data.sortName
	}
	
    var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Heading("🇬🇧 - \(pollingDistrict?.name ?? "<Unknown PD>")")
			Divider()
			Group {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Wards")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					Text("\(pollingDistrict?.wards?.count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Streets")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					Text("\(pollingDistrict?.getStreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Substreets")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					Text("\(pollingDistrict?.getSubstreets().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Properties")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					Text("\(pollingDistrict?.getAbodes().count ?? 0)")
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Electors")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					Text("\(pollingDistrict?.getElectors().count ?? 0)")
				}
			}
			Divider()
			Group {
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Name")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					TextField("Polling district name", text: $data.name)
						.disabled(!editMode)
				}
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Sort name")
						.decidesWidthOf(measure, key: "PROMPT", alignment: .trailing)
					TextField("Polling district sort name", text: $data.sortName)
						.disabled(!editMode)
				}
				HStack(alignment: .firstTextBaseline) {
					Spacer()
					if editMode {
						Button {
							editMode = false
							save()
							delegate?.update(item: pollingDistrict)
						} label: {
							Text("OK")
						}
						Button {
							editMode = false
							data.name = pollingDistrict?.name ?? ""
							data.sortName = pollingDistrict?.sortName ?? ""
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

struct View_PollingDistrict_Previews: PreviewProvider {
    static var previews: some View {
        View_PollingDistrict()
    }
}
