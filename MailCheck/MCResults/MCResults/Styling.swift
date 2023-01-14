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
	
	@ObservedObject var vw = MeasuringView()

	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("First")
					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW1")
				Divider()
					.followsHeightOf(vw, key: "ROW1")
					.frame(width: 1)
				Text("First part Two")
					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW1")
				Divider()
					.followsHeightOf(vw, key: "ROW1")
					.frame(width: 1)
				Text("First part Three")
					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW1")
			}
			.decidesWidthOf(vw, key: "WIDTH")
			Divider()
				.followsWidthOf(vw, key: "WIDTH")
			HStack {
				Text("Second")
					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
				Divider()
					.followsHeightOf(vw, key: "ROW2")
					.frame(width: 1)
				Text("Second part Two")
					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
				Divider()
					.followsHeightOf(vw, key: "ROW2")
					.frame(width: 1)
				Text("Second part Three")
					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
			}
			.decidesWidthOf(vw, key: "WIDTH")
			Divider()
				.followsWidthOf(vw, key: "WIDTH")
			HStack {
				Text("Second")
					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
				Divider()
					.followsHeightOf(vw, key: "ROW2")
					.frame(width: 1)
				Text("Second part Two")
					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
				Divider()
					.followsHeightOf(vw, key: "ROW2")
					.frame(width: 1)
				Text("Second part Three")
					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
					.decidesHeightOf(vw, key: "ROW2")
			}
			.decidesWidthOf(vw, key: "WIDTH")
		}
		
	}
}

struct Styling_Previews: PreviewProvider {
	static var previews: some View {
		Styling()
	}
}
