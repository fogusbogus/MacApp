//
//  MainScreen.Message.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 16/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct MainScreen_Message: View {
	var body: some View {
		VStack {
			HStack {
				Text("MESSAGE")
					.multilineTextAlignment(.leading)
					.font(.system(Font.TextStyle.title2))
				Spacer()
			}
			GeometryReader { geo in
				HStack(alignment: .top) {
					
					VStack(alignment: .center) {
						Image(systemName: "message.fill")
							.resizable()
							.frame(width: 48, height: 48, alignment: .top)
							.foregroundColor(.white)
							.aspectRatio(contentMode: ContentMode.fit)
							
							.background(Color.red)
					}
					.frame(width: 64, height: .infinity, alignment: .top)
					.background(Color.red)
					.border(Color.black)

					VStack {
						HStack {
							Text("Message from Electoral Services")
								.bold()
								.multilineTextAlignment(.leading)
							Spacer()
						}
						HStack {
							Text("A resident in this road has reported a flooding. Please can you confirm this?\n\n\nBlah-blah")
								.multilineTextAlignment(.leading)
							Spacer()
						}
						
					}
					.padding(.leading, 24)
					.frame(width: .infinity, height: .none, alignment: .top)
					Spacer()
				}
				.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
				.padding([.leading, .trailing], 24)
			}
			
			Spacer()
		}
		.padding([.leading, .trailing], 24)
	}
}

struct MainScreen_Message_Previews: PreviewProvider {
	static var previews: some View {
		MainScreen_Message()
	}
}
