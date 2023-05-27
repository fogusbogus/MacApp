//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

struct NewWard: View {
	
	var pollingDistrict: PollingDistrict?
	var delegate: NewWardDelegate?

	
	@State var name: String = ""
	@State var sortName: String = ""
	var warning: String {
		get {
			if pollingDistrict == nil {
				return "Not attached to a valid polling district!"
			}
			
			let wdName = name.trim()
			if wdName.length() == 0 {
				return "Name must have a valid value"
			}
			
			if !pollingDistrict!.getWards().allSatisfy {!$0.name!.implies(name)} {
				return "Ward already exists within this polling district"
			}
			return ""
		}
	}
	
	func canOK() -> Bool {
		return warning.length() == 0
	}
	
	@ObservedObject var measure: MeasuringView = MeasuringView()
	
    var body: some View {
		VStack(alignment: .center, spacing: 4) {
			Group {
				HStack {
					Text("New Ward")
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
					.frame(height: 16)
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Polling district:")
						.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
					Text(pollingDistrict?.name ?? "<Unknown Polling District>").bold()
					Spacer()
				}
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Name:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				TextField("Ward name", text: $name)
			}
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Sort name:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				TextField("Alphanumeric ordering tag", text: $sortName)
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment:.center) {
				if warning != "" {
					Text("⚠️")
					Text(warning)
				}
				Spacer()
				Button("OK") {
					delegate?.okNew(pollingDistrict: pollingDistrict, name: name, sortName: sortName)
				}
				.disabled(!canOK())
				Button("Cancel") {
					delegate?.cancelNew(pollingDistrict: pollingDistrict)
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}

protocol NewWardDelegate {
	func cancelNew(pollingDistrict: PollingDistrict?)
	func okNew(pollingDistrict: PollingDistrict?, name: String, sortName: String)
}

struct NewWard_Previews: PreviewProvider {
    static var previews: some View {
        NewWard()
    }
}
