//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

struct NewSubStreet: View {
	
	var street: Street?
	var delegate: NewSubStreetDelegate?
	
	@State var name: String = ""
	@State var sortName: String = ""
	var warning: String {
		get {
			if street == nil {
				return "Not attached to a valid street!"
			}
			
			let ssName = name.trim()
			if ssName.length() == 0 {
				return "Name must have a valid value"
			}
			
			if !street!.getSubStreets().allSatisfy {!$0.name!.implies(name)} {
				return "Substreet already exists within this street"
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
					Text("New Substreet")
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
					.frame(height: 16)
				HStack(alignment: .firstTextBaseline, spacing: 8) {
					Text("Street:")
						.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
					Text(street?.name ?? "<Unknown Street>").bold()
					Spacer()
				}
			}
			Spacer()
				.frame(height: 24)
			HStack(alignment: .firstTextBaseline, spacing: 8) {
				Text("Name:")
					.decidesWidthOf(measure, key: "LABEL", alignment: .trailing)
				TextField("Substreet name", text: $name)
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
					delegate?.okNew(street: street, name: name, sortName: sortName)
				}
				.disabled(!canOK())
				Button("Cancel") {
					delegate?.cancelNew(street: street)
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}

protocol NewSubStreetDelegate {
	func cancelNew(street: Street?)
	func okNew(street: Street?, name: String, sortName: String)
}

struct NewSubStreet_Previews: PreviewProvider {
    static var previews: some View {
        NewSubStreet()
    }
}
