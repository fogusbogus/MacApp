//
//  MainScreen.History.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 20/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct MainScreen_History: View {
	var body: some View {
		VStack {
			HistoryTitle()
			HistoryContent()
				.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
				.padding(.leading, 32)
				.padding(.trailing, 24)
		}
	}
}

struct MainScreen_History_Previews: PreviewProvider {
	static var previews: some View {
		MainScreen_History()
	}
}

struct HistoryContent: View {
	var body: some View {
		HStack(alignment: .top) {
			VStack {
				Image(systemName: "message.fill")
				.resizable()
				.frame(width: 48, height: 48, alignment: .top)
				.foregroundColor(.white)
				.background(Color.purple)
				.multilineTextAlignment(.leading)
					.cornerRadius(8)
		}
//			.frame(width: .infinity, height: .ulpOfOne, alignment: .bottomTrailing)
			VStack(alignment: .leading) {
				HStack(alignment: .top) {
					Text("Last Action with some really really really really really really long text")
						.bold()
					Spacer()
				}
				HStack(alignment: .top) {
					Text("New property added\n\nSomething else")
						.multilineTextAlignment(.leading)
					Spacer()
				}
			}
			Spacer()
			VStack {
				Text("Matt Hogg")
			}

			VStack(alignment: .leading) {
				Text("20/04/2015 19:22")
					.font(.system(.headline))
					.padding([.trailing], 8)
			}
			
		}
	}
}

struct HistoryTitle: View {
	var body: some View {
		HStack {
			Text("ACTION HISTORY")
				.font(.system(.largeTitle))
			Spacer()
		}
		.padding([.leading, .trailing], 24)
	}
}
