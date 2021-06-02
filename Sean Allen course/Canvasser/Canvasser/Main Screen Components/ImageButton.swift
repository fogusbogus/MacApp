//
//  ImageButton.swift
//  Canvasser
//
//  Created by Matt Hogg on 16/01/2021.
//

import SwiftUI

struct ImageButton : View {
	
	var systemName: String
	var iconSize: CGFloat
	var fgColor: Color
	var bgColor: Color
	var offset: CGSize = CGSize.zero
	var shadow: Color = .black
	var shadowSize: CGFloat = CGFloat.zero
	var enabled: Bool = true
	
	var tapAction : () -> Void = {}
	
	var body : some View {
		Image(systemName: systemName)
			.resizable()
			.frame(width: iconSize, height: iconSize, alignment: .center)
			.foregroundColor(fgColor)
			.background(bgColor)
			.cornerRadius(CGFloat(iconSize / 2))
			.offset(offset)
			.shadow(color: shadow, radius: shadowSize)
			.onTapGesture {
				tapAction()
			}
			.disabled(!enabled)
	}
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
		ImageButton(systemName: "plus", iconSize: 48, fgColor: .white, bgColor: .green)
    }
}
