//
//  DataEntry.Heading.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 22/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct DataEntry_Heading: View {
    var body: some View {
		HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
			Spacer()
			Text("Frederick Bloggs")
				.font(.system(.largeTitle))
				.foregroundColor(Color("MainHeader.text"))
			Spacer()
		})
		.padding(.all, 24)
		.background(LinearGradient(gradient: Gradient(colors: [Color("MainHeader.back.end"), Color("MainHeader.back.start")]), startPoint: .top, endPoint: .bottom))
		.edgesIgnoringSafeArea(.all)
    }
}

struct DataEntry_Heading_Previews: PreviewProvider {
    static var previews: some View {
        DataEntry_Heading()
    }
}
