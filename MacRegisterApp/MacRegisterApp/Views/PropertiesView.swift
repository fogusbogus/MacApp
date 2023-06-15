//
//  PropertiesView.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 28/05/2023.
//

import SwiftUI
import MeasuringView

struct Banner : View {
	var title: String
	var body: some View {
		HStack {
			Text(title).bold()
			Spacer()
		}.padding([.leading, .trailing], 4).padding([.top, .bottom], 2).background(.gray)
	}
}

protocol PropertyViewDelegate {
	func selectionChanged(abode: Abode?)
	func getSelectedAbode() -> Abode?
}

struct PropertiesView: View {
	
	var substreet: SubStreet?
	var street: Street?
	var delegate: PropertyViewDelegate?
	var contextMenuDelegate: ContextMenuProviderDelegate?
	
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
		VStack(alignment: .leading) {
			Banner(title: "Properties")
			Table(getAbodes(), selection: $selection) {
					TableColumn("Type") { rec in
						Text(rec.typeAsIcon)
							.contextMenuForWholeItem()
							.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedAbode())})
					}
					.width(min: 32, max: 32)
					TableColumn("Name") { rec in
						Text(rec.name ?? "")
							.contextMenuForWholeItem()
							.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedAbode())})
					}
					TableColumn("Elector count") { rec in
						Text(rec.electorCountAsString)
							.contextMenuForWholeItem()
							.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedAbode())})
					}
					.width(min: 96, max: 96)
			}
			.onChange(of: selection) { newValue in
				delegate?.selectionChanged(abode: getAbodes().first {ObjectIdentifier($0) == newValue})
			}
		}
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
