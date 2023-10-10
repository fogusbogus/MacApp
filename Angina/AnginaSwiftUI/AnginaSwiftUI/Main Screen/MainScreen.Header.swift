//
//  MainScreen.Header.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 16/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct MainScreen_Header: View {
	
	struct MainScreenHeaderData {
		var title : String = "Mobile Canvasser"
		var searchEnabled : Bool = true
		var syncActive : Bool = false
		var filterEnabled : Bool = true
		var alertEnabled : Bool = true
	}
	
	@Binding var data : MainScreenHeaderData
	
	func iconColor(_ isSet: Bool) -> Color {
		return isSet ? Color("MainHeader.icon.enabled") : Color("MainHeader.icon.disabled")
	}
	
	
	var iconSize = CGFloat(48)
    var body: some View {
		HStack {
			//Burger
			HStack {
				StandardIcon(systemName: "gear", iconColor: iconColor(true))
				IddyBiddySpacer()
			}
			//Title
			Text(data.title)
				.font(.system(.largeTitle))
				.foregroundColor(Color("MainHeader.text"))
				.bold()
			Spacer()
			//SearchIcon
			StandardIcon(systemName: "magnifyingglass", iconColor: iconColor(data.searchEnabled))
				.disabled(!data.searchEnabled)
			IddyBiddySpacer()
			//SyncIcon - icloud.and.arrow.down
			StandardIcon(systemName: "icloud.and.arrow.down", iconColor: iconColor(data.syncActive))
				//.disabled(!data.syncActive)
			IddyBiddySpacer()
			//FilterIcon
			StandardIcon(systemName: "slider.horizontal.3", iconColor: iconColor(data.filterEnabled))
				.disabled(!data.filterEnabled)
			IddyBiddySpacer()
			//AlertIcon
			StandardIcon(systemName: "exclamationmark.triangle.fill", iconColor: iconColor(data.alertEnabled))
				.disabled(!data.alertEnabled)
		}
		.padding([.leading, .trailing], 24)
		.background(LinearGradient(gradient: Gradient(colors: [Color("MainHeader.back.start"), Color("MainHeader.back.end")]), startPoint: .leading, endPoint: .trailing))
		.edgesIgnoringSafeArea(.all)
    }
}

struct MainScreen_Header_Previews: PreviewProvider {
	@State static var data = MainScreen_Header.MainScreenHeaderData(title: "Mobile Canvasser", searchEnabled: true, syncActive: false, filterEnabled: true, alertEnabled: true)
    static var previews: some View {
		VStack {
			MainScreen_Header(data: $data)
			Spacer()
		}
    }
}
