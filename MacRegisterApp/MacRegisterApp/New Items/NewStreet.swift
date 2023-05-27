//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

struct NewStreet: View {
	
	var ward: Ward?
	var delegate: NewStreetDelegate?

	
	@State var name: String = ""
	@State var sortName: String = ""
	var warning: String {
		get {
			if ward == nil {
				return "Not attached to a valid ward!"
			}
			
			let stName = name.trim()
			if stName.length() == 0 {
				return "Name must have a valid value"
			}
			
			if !ward!.getStreets().allSatisfy {!$0.name!.implies(name)} {
				return "Street already exists within this Ward"
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
					Text("New Street")
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
					.frame(height: 16)
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Ward:")
						.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
					Text(ward?.name ?? "<Unknown Ward>").bold()
					Spacer()
				}
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Name:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				TextField("Street name", text: $name)
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
					delegate?.okNew(ward: ward, name: name, sortName: sortName)
				}
				.disabled(!canOK())
				Button("Cancel") {
					delegate?.cancelNew(ward: ward)
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}

protocol NewStreetDelegate {
	func cancelNew(ward: Ward?)
	func okNew(ward: Ward?, name: String, sortName: String)
}

struct NewStreet_Previews: PreviewProvider {
    static var previews: some View {
        NewStreet()
    }
}
