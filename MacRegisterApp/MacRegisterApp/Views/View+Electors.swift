//
//  View+Electors.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 09/06/2023.
//

import SwiftUI

protocol ViewElectorsDelegate {
	func getSelectedElector() -> Elector?
	func select(elector: Elector?)
}

extension Elector {
	func getMarkerSymbols() -> String {
		if let rawValue = Int(self.markers ?? "0") {
			return Marker(rawValue: rawValue)?.symbols ?? ""
		}
		return ""
	}
}

struct View_Electors: View {
	var property: Abode?
	
	@State var selection: Elector.ID? = nil
	
	var contextMenuDelegate: ContextMenuProviderDelegate?
	var delegate: ViewElectorsDelegate?
	
	private func getElectors() -> [Elector] {
		return property?.getElectors() ?? []
	}
	
	var body: some View {
		//ScrollView {
		VStack(alignment: .leading) {
			Banner(title: "Electors in \(property?.location ?? "")")
			Table(getElectors(), selection: $selection) {
				TableColumn("Name") { rec in
					Text(rec.name ?? "")
						.contextMenuForWholeItem()
						.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedElector())})
				}
				TableColumn("Markers") { rec in
					Text(rec.getMarkerSymbols())
						.contextMenuForWholeItem()
						.contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedElector())})
				}
				.width(min: 96, max: 200)
			}
			.onChange(of: selection) { newValue in
				let elector = getElectors().first {ObjectIdentifier($0) == newValue}
				delegate?.select(elector: elector)
			}
		}
	}
}


struct View_Electors_Previews: PreviewProvider {
    static var previews: some View {
		View_Electors(property: Abode.getAll().first!)
    }
}
