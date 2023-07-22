//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

class NewWardDetails: DataNavigationalDetailsForEditing<Ward> {
	
	@State var name: String = ""
	@State var sortName: String = ""
	
	enum NewWardDetailsError : Error {
		case noValidPollingDistrict, invalidName, nameAlreadyExists
	}
	
	/// Provide some means of validating our data
	/// - Parameter parent: We might not have a parent yet, but a potential one
	/// - Returns: An array of errors
	override func errors(parent: DataNavigational?) -> [Error] {
		var ret: [Error] = []
		let pollingDistrict = parent as? PollingDistrict ?? object?.pollingDistrict
		if pollingDistrict == nil {
			ret.append(NewWardDetailsError.noValidPollingDistrict)
		}
		if name.trim().isEmptyOrWhitespace() {
			ret.append(NewWardDetailsError.invalidName)
		}
		
		if let object = object, let _ = pollingDistrict?.getWards().map({$0 as DataNavigational}).named(name, butNot: object) {
			ret.append(NewWardDetailsError.nameAlreadyExists)
		}
		return ret
	}
	
	override func copyToObject(_ object: Ward?) {
		object?.name = name
		object?.sortName = sortName
	}
	
	override func copyObject(object: Ward?) {
		self.object = object
		self.name = object?.name ?? ""
		self.sortName = object?.sortName ?? ""
	}
	
	override func canSave(withParent: DataNavigational? = nil) -> Bool {
		return errors(parent: withParent).count == 0
	}
}

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
			
			if !pollingDistrict!.getWards().allSatisfy({!$0.name!.implies(name)}) {
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
