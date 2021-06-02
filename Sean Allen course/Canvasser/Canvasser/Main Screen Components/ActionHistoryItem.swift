//
//  ActionHistory.swift
//  Canvasser
//
//  Created by Matt Hogg on 23/01/2021.
//

import SwiftUI

struct ActionHistoryItem: View {
	
	var calcHeight : CGFloat = 48
	@ObservedObject var icoHeight = BindingCGFloat(height: 48)
	
	var body: some View {
		VStack {
			HStack(alignment: .top, spacing: 24, content: {
				VStack {
					Image(systemName: "list.triangle")
						.resizable()
						.scaledToFit()
						.frame(width: 48, height: 48, alignment: .center)
						.aspectRatio(contentMode: .fill)
						.foregroundColor(.yellow)
					//.padding(.top, 16)
				}
				VStack(alignment: .leading, spacing: 8, content: {
					Text("History Item")
						.bold()
					Text("Change of name")
						.italic()
				})
				Spacer()
				Text("Joe Bloggs")
					.italic()
				
				Text("5-Apr-20 11:55")
					.italic()
					.padding([.leading, .trailing], 24)
				
			})
			.padding([.leading, .trailing, .top, .bottom], 24)
			.border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
			.background(Color.gray)
		}
		.padding([.leading, .trailing], 24)
	}
}




struct ActionHistory_Previews: PreviewProvider {
	static var previews: some View {
		ActionHistoryItem()
			.preferredColorScheme(.dark)
			.previewDevice("iPad Pro (9.7-inch)")
	}
}
