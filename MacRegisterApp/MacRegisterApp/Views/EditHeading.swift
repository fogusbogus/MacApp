//
//  EditHeading.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 06/06/2023.
//

import SwiftUI

struct DataNavigationalHeading<Content:View>: View {
	
	var symbol: String
	var name: String
	var content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(symbol + " - " + name)
				.font(.title)
			Divider()
			Form {
				Section {
					content()
				}
			}
		}
	}
}

struct EditHeading<T: DataNavigational>: View {
	var object: T?
	
    var body: some View {
		DataNavigationalHeading(symbol:object?.symbol ?? "", name: object?.objectName ?? "") {
			Group {
				if let pd = object as? PollingDistrict {
					LabeledContent("Wards", value: "\(pd.wardCount)")
					LabeledContent("Streets", value: "\(pd.streetCount)")
					LabeledContent("Substreets", value: "\(pd.subStreetCount)")
					LabeledContent("Properties", value: "\(pd.propertyCount)")
					LabeledContent("Electors", value: "\(pd.electorCount)")
				}
				if let wd = object as? Ward {
					LabeledContent("Polling district", value: wd.pollingDistrict?.name ?? "")
					LabeledContent("Streets", value: "\(wd.streetCount)")
					LabeledContent("Substreets", value: "\(wd.subStreetCount)")
					LabeledContent("Properties", value: "\(wd.propertyCount)")
					LabeledContent("Electors", value: "\(wd.electorCount)")
				}
				if let st = object as? Street {
					LabeledContent("Polling district", value: st.ward?.pollingDistrict?.name ?? "")
					LabeledContent("Ward", value: st.ward?.name ?? "")
					LabeledContent("Substreets", value: "\(st.subStreetCount)")
					LabeledContent("Properties", value: "\(st.propertyCount)")
					LabeledContent("Electors", value: "\(st.electorCount)")
				}
				if let ss = object as? SubStreet {
					LabeledContent("Polling district", value: ss.street?.ward?.pollingDistrict?.name ?? "")
					LabeledContent("Ward", value: ss.street?.ward?.name ?? "")
					LabeledContent("Street", value: ss.street?.name ?? "")
					LabeledContent("Properties", value: "\(ss.propertyCount)")
					LabeledContent("Electors", value: "\(ss.electorCount)")
				}
			}
		}
		
	}
}

struct EditForm<T: DataNavigational> : View {
	var data: T
	var body: some View {
		Form {
			EditHeading(object: data)
			Divider()
			EditArea(object: data)
		}
		.padding()
	}
}

struct EditHeading_Previews: PreviewProvider {
    static var previews: some View {
		Form {
			EditHeading(object: SubStreet.getAll().first)
			Divider()
			EditArea(object: SubStreet.getAll().first)
		}
		.padding()
    }
}

struct EditArea: View {
	
	init(object: DataNavigational? = nil) {
		self.object = object
		self.name = object?.objectName ?? ""
		self.sortName = object?.sortingName ?? ""
	}
	
	var object: DataNavigational? {
		didSet {
			self.name = object?.objectName ?? ""
			self.sortName = object?.sortingName ?? ""
		}
	}
	
	@State var name: String = ""
	@State var sortName: String = ""
	@State var editMode: Bool = false
	var id = UUID()
	
	var body: some View {
		Group {
			TextField("Name", text: $name)
				.disabled(!editMode)
			TextField("Sort name", text: $sortName)
				.disabled(!editMode)
			HStack(alignment: .center) {
				Spacer()
				if editMode {
					Button {
						editMode = false
						if let obj = object as? NSManagedObject {
							try? obj.managedObjectContext?.save()
						}
						self.name = object?.objectName ?? ""
						self.sortName = object?.sortingName ?? ""
					} label: {
						Text("OK")
					}
					Button {
						editMode = false
						self.name = object?.objectName ?? ""
						self.sortName = object?.sortingName ?? ""
					} label: {
						Text("Cancel")
					}
				}
				else {
					Button {
						
					} label: {
						Text("Edit")
							.onTapGesture {
								editMode = true
							}
					}
				}
			}
		}
		.onAppear {
			self.name = object?.objectName ?? ""
			self.sortName = object?.sortingName ?? ""
		}
	}
}

extension PollingDistrict {
	var wardCount: Int {
		get {
			return wards?.count ?? 0
		}
	}
	
	var streetCount: Int {
		get {
			return getStreets().count
		}
	}
	
	var subStreetCount: Int {
		get {
			return getSubstreets().count
		}
	}
	
	var propertyCount: Int {
		get {
			return getAbodes().count
		}
	}
	
	var electorCount: Int {
		get {
			return getElectors().count
		}
	}
}

extension Ward {
	var streetCount: Int {
		get {
			return streets?.count ?? 0
		}
	}
	
	var subStreetCount: Int {
		get {
			return getSubstreets().count
		}
	}
	
	var propertyCount: Int {
		get {
			return getAbodes().count
		}
	}
	
	var electorCount: Int {
		get {
			return getElectors().count
		}
	}
}

extension Street {
	
	var subStreetCount: Int {
		get {
			return subStreets?.count ?? 0
		}
	}
	
	var propertyCount: Int {
		get {
			return getAbodes().count
		}
	}
	
	var electorCount: Int {
		get {
			return getElectors().count
		}
	}
}

extension SubStreet {
	
	func getElectors() -> [Elector] {
		var ret: [Elector] = []
		getAbodes().forEach {ret.append(contentsOf: $0.getElectors())}
		return ret
	}
	
	var propertyCount: Int {
		get {
			return abodes?.count ?? 0
		}
	}
	
	var electorCount: Int {
		get {
			return getElectors().count
		}
	}
}

extension Abode {
	
	var electorCount: Int {
		get {
			return electors?.count ?? 0
		}
	}
}

