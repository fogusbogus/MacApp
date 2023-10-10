//
//  StandardIcon.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 16/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI

struct StandardIcon: View {
	var systemName : String
	var iconColor : Color
	var iconSize = CGFloat(48)
	var frameWidth = CGFloat(48)
	var frameHeight = CGFloat(48)
	var alignment : Alignment = .center
	
    var body: some View {
		Image(systemName: systemName)
			.resizable()
			.frame(width: frameWidth, height: frameHeight, alignment: alignment)
			.padding()
			.foregroundColor(iconColor)
			.aspectRatio(contentMode: .fit)
			.cornerRadius(8)
    }
}

struct IddyBiddySpacer : View {
	var body : some View {
		Image("")
			.frame(width: 32, height: .infinity, alignment: .center)
	}
}

struct StandardIcon_Previews: PreviewProvider {
    static var previews: some View {
		StandardIcon(systemName: "", iconColor: .white)
    }
}
