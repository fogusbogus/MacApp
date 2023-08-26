//
//  StandardButton.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 21/08/2023.
//

import Foundation
import SwiftUI

struct StandardButton: ButtonStyle {
	
	var background = Color.blue
	var foreground = Color.white
	
	func makeBody(configuration: Self.Configuration) -> some View {
		return configuration.label
			.padding([.top, .bottom], 4)
			.padding([.leading, .trailing])
			.background(background.opacity(0.5))
			.foregroundColor(foreground)
			.clipShape(Capsule())
			.opacity(configuration.isPressed ? 0.7 : 1)
			.scaleEffect(configuration.isPressed ? 0.8 : 1)
			.animation(.easeInOut(duration: 0.2), value: 1)
	}
}

