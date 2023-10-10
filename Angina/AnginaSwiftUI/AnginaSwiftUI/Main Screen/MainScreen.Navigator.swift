//
//  MainScreen.Navigator.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 16/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct MainScreen_Navigator: View {
	
	enum NavEnum {
		case streets
		case properies
		case electors
	}
	
	struct MainScreenNavigatorData {
		var history : [String] = []
		var hasGPS : Bool = false
		var title : String {
			get {
				let last = history.last
				if last == nil || last == "" {
					return "Streets"
				}
				return last!
			}
		}
		
		var home : Bool {
			get {
				return history.count > 0
			}
		}
	}
	
	@Binding var data : MainScreenNavigatorData
	
	func iconColor(_ isSet: Bool) -> Color {
		return isSet ? Color("MainHeader.icon.enabled") : Color("MainHeader.icon.disabled")
	}
	var iconSize = CGFloat(48)

	
    var body: some View {
		HStack {
			StandardIcon(systemName: "arrow.backward", iconColor: iconColor(data.home))
			IddyBiddySpacer()
			StandardIcon(systemName: "mappin.and.ellipse", iconColor: iconColor(data.hasGPS))
			Spacer()
			Text(data.title)
				.foregroundColor(Color("MainHeader.text"))
				.font(.system(.largeTitle))
				.bold()
			Spacer()
			StandardIcon(systemName: "house.fill", iconColor: iconColor(data.home))
		}
		.padding([.leading, .trailing], 24)
		.background(LinearGradient(gradient: Gradient(colors: [Color("MainHeader.back.end"), Color("MainHeader.back.start")]), startPoint: .top, endPoint: .bottom))
		.edgesIgnoringSafeArea(.all)
    }
}

struct MainScreen_Navigator_Previews: PreviewProvider {
	
	@State static var data = MainScreen_Navigator.MainScreenNavigatorData(history: ["Berkeley Close", "11, Berkeley Close"], hasGPS: false)
	
    static var previews: some View {
		MainScreen_Navigator(data: $data)
    }
}
