//
//  Styling.swift
//  MCResults
//
//  Created by Matt Hogg on 09/01/2023.
//

import SwiftUI

class StylingConstants {
	static var cornerRadiusLarge : CGFloat = 8
	static var cornerRadiusSmall : CGFloat = 2
}

extension Button {
	func standardBlue() -> some View {
		return self
			.padding([.leading, .trailing], 16)
			.padding([.top, .bottom], 8)
			.background(Color("Button/back"))
			.foregroundColor(Color("Button/fore"))
			.bold()
			.cornerRadius(4)
	}
}

extension View {
	func measured(_ saveValue: @escaping (CGSize) -> Void) -> some View {
		return self
			.overlay {
				GeometryReader { geo in
					Color.clear
						.onAppear() {
							saveValue(geo.size)
						}
						.onChange(of: geo.size) { _ in
							saveValue(geo.size)
						}
				}
			}
	}
	
}

struct StandardGroupBoxStyle: GroupBoxStyle {
	var background: some View {
		RoundedRectangle(cornerRadius: 8)
			.fill(Color.orange)
			.shadow(radius: 16)
	}
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.content
			.padding()
			.background(background)
			.opacity(0.4)
			.overlay(
				configuration.label
					.padding(.leading, 4),
				alignment: .topLeading
			)
	}
}

struct GBS : GroupBoxStyle {
	
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			configuration.content
			Spacer()
		}
		.padding()
		.overlay {
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.stroke(.orange)
			.background(.orange)
			.opacity(0.5)
			.shadow(radius: 5)
			.padding()
			.cornerRadius(16)
			.overlay {
				HStack {
					configuration.content
					Spacer()
				}
				.padding()

			}
		}
	}
	
}

struct Styling : View {
	var body: some View {
//		Group {
//			Text("Test")
//		}
//		.overlay {
//			RoundedRectangle(cornerRadius: 25)
//				.strokeBorder()
//				.background(.orange)
//				.cornerRadius(25)
//		}
		EmptyView()
	}
}

struct Styling_Previews: PreviewProvider {
	static var previews: some View {
		Styling()
	}
}
