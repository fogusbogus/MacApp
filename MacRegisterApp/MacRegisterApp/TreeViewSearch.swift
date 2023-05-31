//
//  TreeViewSearch.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 30/05/2023.
//

import SwiftUI

struct TreeViewSearch: View {
	@State var searchText: String = ""
	var body: some View {
		Group {
			TextField("", text: $searchText)
				.border(.clear)
				.padding([.leading, .trailing], 28)
				.overlay {
					HStack(alignment: .center) {
						Image(systemName: "magnifyingglass")
							.frame(width:24, height:24)
						Spacer()
						Image(systemName: "xmark.circle.fill")
							.frame(width:24, height:24)
					}
				}
		}
	}
}


struct TreeViewSearch_Previews: PreviewProvider {
    static var previews: some View {
        TreeViewSearch()
    }
}
