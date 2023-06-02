//
//  Heading.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/06/2023.
//

import SwiftUI

struct Heading: View {
	
	init(_ text: String = "") {
		self.text = text
	}
	
	var text: String = ""
	
    var body: some View {
		Text(text)
			.font(.largeTitle)
    }
}

struct Heading_Previews: PreviewProvider {
    static var previews: some View {
        Heading()
    }
}
