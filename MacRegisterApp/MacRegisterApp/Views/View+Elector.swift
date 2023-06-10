//
//  View+Elector.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 09/06/2023.
//

import SwiftUI

struct View_Elector: View {
	var property: Abode
	
	@State var selection: Elector.ID? = nil
	
	private func getElectors() -> [Elector] {
		return property.getElectors()
	}
	
	var body: some View {
		//ScrollView {
		VStack(alignment: .leading) {
			Banner(title: "Electors in \(property.address)")
			Table(getElectors(), selection: $selection) {
				TableColumn("Name") { rec in
					Text(rec.name ?? "")
				}
				.width(min: 32, max: 32)
				TableColumn("Markers") { rec in
					Text(rec.markers ?? "")
				}
			}
			.onChange(of: selection) { newValue in
//				delegate?.selectionChanged(abode: getAbodes().first {ObjectIdentifier($0) == newValue})
			}
		}
	}
}


struct View_Elector_Previews: PreviewProvider {
    static var previews: some View {
		View_Elector(property: Abode.getAll().first!)
    }
}
