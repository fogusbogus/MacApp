//
//  MainScreen.swift
//  Canvasser
//
//  Created by Matt Hogg on 03/02/2021.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
		VStack(alignment: .leading, spacing: 8, content: {
			TitleBar()
			NavBar(clickDelegate: { (navBar, action) in
				
			}, data: NavBarData())
			MainScreen_Splits(numOfSplits:24)
		})
	
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
