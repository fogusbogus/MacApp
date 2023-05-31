//
//  PropertiesView.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 28/05/2023.
//

import SwiftUI
import MeasuringView

protocol PropertyViewDelegate {
	func selectionChanged(abode: Abode?)
}

struct PropertiesView: View {
	
	var substreet: SubStreet?
	var street: Street?
	var delegate: PropertyViewDelegate?
	
	@State var selection: Abode.ID?
	
	@ObservedObject var measure = PersistenceController.shared.measuring
	
	func getAbodes() -> [Abode] {
		if let substreet = substreet {
			return substreet.getAbodes().sorted(by: {$0.sorterText() < $1.sorterText()})
		}
		if let street = street {
			return street.getAbodes().sorted(by: {$0.sorterText() < $1.sorterText()})
		}
		return []
	}
	
	var body: some View {
		//ScrollView {
		Table(getAbodes(), selection: $selection) {
			TableColumn("Type") { rec in
				Text(rec.typeAsIcon)
			}
			.width(min: 32, max: 32)
			TableColumn("Name") { rec in
				Text(rec.name ?? "")
			}
			TableColumn("Elector count") { rec in
				Text(rec.electorCountAsString)
			}
			.width(min: 96, max: 96)
		}
		.onChange(of: selection) { newValue in
			delegate?.selectionChanged(abode: getAbodes().first {ObjectIdentifier($0) == newValue})
		}
		//			VStack(alignment: .leading, spacing: 8) {
		//				HStack(alignment: .firstTextBaseline, spacing: 8) {
		//					Text(" ")
		//						.decidesWidthOf(measure, key: "TYPE", alignment: .leading)
		//					Text("Name")
		//						.decidesWidthOf(measure, key: "NAME", alignment: .leading)
		//					Text("Elector count")
		//						.decidesWidthOf(measure, key: "COUNT", alignment: .leading)
		//				}
		//				ForEach(getAbodes(), id:\.self) { pr in
		//					HStack(alignment: .firstTextBaseline, spacing: 8) {
		//						Text("🏠")
		//							.decidesWidthOf(measure, key: "TYPE", alignment: .leading)
		//						Text(pr.name ?? "?")
		//							.decidesWidthOf(measure, key: "NAME", alignment: .leading)
		//						Text("\(pr.electors?.count ?? 0)")
		//							.decidesWidthOf(measure, key: "COUNT", alignment: .leading)
		//					}
		//				}
		//			}
		//}
	}
}

struct PropertiesView_Previews: PreviewProvider {
	static var previews: some View {
		PropertiesView()
	}
}

extension SubStreet {
	func getAbodes() -> [Abode] {
		return self.abodes?.allObjects.compactMap {$0 as? Abode}.sorted(by: {$0.sorterText() < $1.sorterText()}) ?? []
	}
}

extension Street {
	func getAbodes() -> [Abode] {
		var ret : [Abode] = []
		self.getSubStreets().forEach { ss in
			ret.append(contentsOf: ss.getAbodes())
		}
		return ret
	}
}

extension Abode {
	var electorCountAsString: String {
		get {
			if let count = electors?.count {
				return "\(count)"
			}
			return "-"
		}
	}
	
	var typeAsIcon: String {
		get {
			switch type ?? "" {
				case "C":
					return "🏢"
				default:
					return "🏠"
			}
		}
	}
}
