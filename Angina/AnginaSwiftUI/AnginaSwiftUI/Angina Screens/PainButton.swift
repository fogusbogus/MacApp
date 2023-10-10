//
//  PainButton.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 31/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI


struct PainButton : View {
	
	@Binding var painPoint : PainPoint
	
	var size : Int = 48
	
	func fillColor() -> Color {
		switch painPoint.pain {
			case 0:
				return .white
			case 1:
				return .yellow
			case 2:
				return .red
			default:
				return .white
		}
	}
	
	func changePain() {
		painPoint.pain = (painPoint.pain + 1) % 3
	}
	
	var body: some View {
		ZStack {
			Circle()
				.fill(Color.white)
				.frame(width: CGFloat(size + 2), height: CGFloat(size + 2), alignment: .center)
			Circle()
				.fill(Color.black)
				.frame(width: CGFloat(size + 1), height: CGFloat(size + 1), alignment: .center)
			Circle()
				.fill(fillColor())
				.frame(width: CGFloat(size - 1), height: CGFloat(size - 1), alignment: .center)
			Text("X")
			//.bold()
		}
		.onTapGesture {
			changePain()
		}
	}
}


struct PainButton_Previews: PreviewProvider {
	@State static var pp : PainPoint = PainPoint(Name: "FRED", x: 0, y: 0)
    static var previews: some View {
        PainButton(painPoint: $pp)
    }
}
