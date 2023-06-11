//
//  View+Electors.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 09/06/2023.
//

import SwiftUI

struct View_Electors: View {
	var property: Abode?
	
	@State var selection: Elector.ID? = nil
	
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
				}
				TableColumn("Markers") { rec in
					Text(rec.markers ?? "")
					
				}
				.width(min: 96, max: 200)
			}
			.onChange(of: selection) { newValue in
//				delegate?.selectionChanged(abode: getAbodes().first {ObjectIdentifier($0) == newValue})
			}
		}
	}
}


struct View_Electors_Previews: PreviewProvider {
    static var previews: some View {
		View_Electors(property: Abode.getAll().first!)
    }
}
