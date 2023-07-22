//
//  NewSubStreet.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import SwiftUI

import MeasuringView
import UsefulExtensions

protocol NewStreetDelegate {
	func cancelEditStreet(street: Street?)
	func saveEditStreet(street: Street?)
	func cancelNewStreet(ward: Ward?)
	func saveNewStreet(ward: Ward?)
	func canEditStreet(street: Street?) -> Bool
}

class StreetDetails : DataNavigationalDetailsForEditing<Street> {
	
	override init() {
		super.init()
	}
	
	init(streetId: NSManagedObjectID) {
		super.init()
		copyObject(object: Street.findById(id: streetId))
	}
	
	init(object: Street) {
		super.init()
		copyObject(object: object)
	}
	
	@Published var name : String = ""
	@Published var sortName: String = ""
	@Published var postCode: String = ""
	
	override func copyToObject(_ object: Street?) {
		if let st = object {
			st.name = self.name
			st.sortName = self.sortName
			st.postCode = self.postCode
		}
	}
	
	override func copyObject(object: Street?) {
		self.object = object
		if let st = object {
			self.name = st.objectName
			self.sortName = st.sortingName
			self.postCode = st.postCode ?? ""
		}
	}
	
	override func canSave(withParent: DataNavigational? = nil) -> Bool {
		guard !name.isEmptyOrWhitespace() else { return false }
		if let st = object {
			let wd = withParent as? Ward ?? st.ward
			if wd?.getStreets().map({$0 as DataNavigational}).named(name, butNot: st) != nil {
				return false
			}
		}
		return true
	}
}

struct NewStreet: View {
	
	var ward: Ward?
	var delegate: NewStreetDelegate?

	@State var details = StreetDetails()

	var warning: String {
		get {
			if ward == nil && details.object == nil {
				return "Not attached to a valid ward!"
			}
			
			let stName = details.object?.objectName ?? ""
			if stName.isEmptyOrWhitespace() {
				return "Name must have a valid value"
			}
			
			if let ward = details.object?.ward ?? ward {
				if ward.getStreets().map({$0 as DataNavigational}).named(stName, butNot: details.object!) != nil {
					return "Street already exists within this Ward"
				}
			}
			return ""
		}
	}
	
	var prompt: String {
		get {
			guard let st = details.object else { return "New Street" }
			return "Edit street \(st.objectName.substitute("unknown"))"
		}
	}
	
	func canOK() -> Bool {
		return warning.length() == 0 && details.canSave()
	}
	
	@State var editMode: Bool = false
	
    var body: some View {
		VStack(alignment: .center, spacing: 4) {
			Group {
				HStack {
					Text(prompt)
						.font(.largeTitle)
					Spacer()
				}
				Spacer()
					.frame(height: 16)
				Form {
					LabeledContent("Polling district:", value: details.object?.ward?.pollingDistrict?.objectName ?? "unknown")
					LabeledContent("Ward:", value: details.object?.ward?.objectName ?? "unknown")
					if ward != nil {
						LabeledContent("Substreets:", value: "\(details.object?.subStreetCount ?? 0)")
						LabeledContent("Properties:", value: "\(details.object?.propertyCount ?? 0)")
						LabeledContent("Electors:", value: "\(details.object?.electorCount ?? 0)")
					}
					Divider()
					Group {
						TextField("Name:", text: $details.name)
						TextField("Sort name:", text: $details.sortName)
						TextField("Post code:", text: $details.postCode)
					}
					.disabled(!editMode)
				}
			}
			Divider()
			HStack(alignment:.center) {
				if editMode {
					if warning != "" {
						Text("⚠️")
						Text(warning)
					}
					Spacer()
					Button("OK") {
						if let st = details.object {
							details.copyToObject(st)
							delegate?.saveEditStreet(street: st)
							delegate?.cancelEditStreet(street: st)
						}
						else {
							delegate?.saveNewStreet(ward: ward)
							delegate?.cancelNewStreet(ward: ward)
						}
					}
					.disabled(!canOK())
					Button("Cancel") {
						if let st = details.object {
							details.copyObject(object: st)
							delegate?.cancelEditStreet(street: st)
						}
						else {
							delegate?.cancelNewStreet(ward: ward)
						}
						editMode = false
					}
				}
				else {
					if let delegate = delegate {
						if delegate.canEditStreet(street: details.object) {
							Spacer()
							Button("Edit") {
								editMode = true
							}
						}
					}
				}
			}
			.frame(alignment: .trailing)
		}
		.padding()
    }
}


struct NewStreet_Previews: PreviewProvider {
    static var previews: some View {
		NewStreet(ward: nil, delegate: nil, details: StreetDetails(object: Street.getAll().first!), editMode: false)
    }
}


