//
//  Header+UI.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import SwiftUI

struct Header_UI: View {
	
	var text: String = "Some description of the lane"
	
	var body: some View {
		
		Text(text)
			.bold()
			.font(.title)
			.foregroundColor(Color("Colors/Lane/Heading/fore"))
			.padding([.leading, .trailing], 25)
			.padding([.top, .bottom], 8)
			.background(Color("Colors/Lane/Heading/back"))
			.cornerRadius(Constants.cornerSize_Heading)
			.overlay( /// apply a rounded border
				RoundedRectangle(cornerRadius: Constants.cornerSize_Heading)
					.stroke(Color("Colors/Lane/Heading/border"), lineWidth: Constants.borderWidth_Heading)
			)
			.padding(Constants.borderWidth_Heading)
	}
}

struct Header_UI_Previews: PreviewProvider {
    static var previews: some View {
        Header_UI()
    }
}
