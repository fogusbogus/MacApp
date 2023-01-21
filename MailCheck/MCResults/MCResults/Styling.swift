//
//  Styling.swift
//  MCResults
//
//  Created by Matt Hogg on 09/01/2023.
//

import SwiftUI
import MeasuringView


enum StylingType {
	case checkHeading, resultHeading, description, accordianHeading, descriptionHeading, descriptionHeadingHighlight, summarySmall, dataHeading, summary, resultTableHeading, resultTableData, numberedHeading, numberedDescription, hyperlink, numberedPoint, verbatimDataHeading, verbatimData
}


extension View {
	func styling(_ type: StylingType) -> some View {
		switch type {
			case .checkHeading:
				return AnyView(self
					.font(.subheadline)
					.opacity(0.6))
				
			case .resultHeading:
				return AnyView(
					self.font(.title3)
						.bold()
				)
				
			case .description:
				return AnyView(
					self.font(.body)
				)
				
			case .accordianHeading:
				return AnyView(
					self.font(.title3).bold()
				)
				
			case .descriptionHeading:
				return AnyView(
					self.font(.title2)
				)
				
			case .descriptionHeadingHighlight:
				return AnyView(
					self.styling(.descriptionHeading)
						.bold()
				)
				
			case .summarySmall:
				return AnyView(
					self.font(.caption2)
				)
				
			case .summary:
				return AnyView(
					self.font(.caption)
				)
				
			case .dataHeading:
				return AnyView(
					self.padding([.top, .bottom], 4)
						.padding([.leading, .trailing])
						.foregroundColor(Color(uiColor: UIColor.systemBackground))
						.background(.primary)
						.font(.caption)
				)
				
			case .resultTableHeading:
				return AnyView(
					self.styling(.description).foregroundColor(.blue)
						.bold()
				)
				
			case .resultTableData:
				return AnyView(
					self.styling(.description)
				)
				
			case .numberedDescription:
				return AnyView(
					self.font(.caption)
				)
				
			case .numberedHeading:
				return AnyView(self.styling(.numberedDescription).bold())
				
			case .hyperlink:
				return AnyView(self.foregroundColor(Color(uiColor: UIColor.link)))
				
			case .numberedPoint:
				return AnyView(
					self
						.padding([.leading, .trailing], 8)
						.padding([.top, .bottom], 4)
						.background(Color("Button/back"))
						.foregroundColor(Color("Button/fore"))
						.bold()
				)
				
			case .verbatimData:
				return AnyView(
					self.font(.caption)
						.padding([.top, .bottom], 4)
				)
			case .verbatimDataHeading:
				return AnyView(
					self.padding([.top, .bottom], 4)
						.padding([.leading, .trailing])
						.foregroundColor(Color(uiColor: UIColor.systemBackground))
						.background(.primary)
						.font(.caption)
				)
		}
	}
}


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
	
	@State var name = ""
	@State var fullname = ""
	@State var icon = ""
	@State var notes = ""
	
	@ObservedObject private var vw = MeasuringView()
	
	var body: some View {
		
		VStack {
			HStack {
				Text("Name")
					.decidesWidthOf(vw, key: "C1", alignment: .trailing)
				TextField("Name", text: $name)
					.border(.gray)
			}
			HStack {
				Text("Full name")
					.decidesWidthOf(vw, key: "C1", alignment: .trailing)
				TextField("Full name", text: $fullname)
					.border(.gray)
			}
			HStack {
				Text("Icon")
					.decidesWidthOf(vw, key: "C1", alignment: .trailing)
				TextField("Icon", text: $icon)
					.border(.gray)
					.frame(maxWidth:48)
				Spacer()
			}
			HStack(alignment: .top) {
				Text("Notes")
					.decidesWidthOf(vw, key: "C1", alignment: .trailing)
				TextEditor(text: $notes)
					.frame(height: 100)
					.border(.gray)
			}
		}
		.padding()
	}
}

//struct Styling : View {
//
//	@ObservedObject var vw = MeasuringView()
//
//	var body: some View {
//		VStack(alignment: .leading) {
//			HStack {
//				Text("First")
//					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW1")
//				Divider()
//					.followsHeightOf(vw, key: "ROW1")
//					.frame(width: 1)
//				Text("First part Two")
//					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW1")
//				Divider()
//					.followsHeightOf(vw, key: "ROW1")
//					.frame(width: 1)
//				Text("First part Three")
//					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW1")
//			}
//			.decidesWidthOf(vw, key: "WIDTH")
//			Divider()
//				.followsWidthOf(vw, key: "WIDTH")
//			HStack {
//				Text("Second")
//					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//				Divider()
//					.followsHeightOf(vw, key: "ROW2")
//					.frame(width: 1)
//				Text("Second part Two")
//					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//				Divider()
//					.followsHeightOf(vw, key: "ROW2")
//					.frame(width: 1)
//				Text("Second part Three")
//					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//			}
//			.decidesWidthOf(vw, key: "WIDTH")
//			Divider()
//				.followsWidthOf(vw, key: "WIDTH")
//			HStack {
//				Text("Second")
//					.decidesWidthOf(vw, key: "COL1", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//				Divider()
//					.followsHeightOf(vw, key: "ROW2")
//					.frame(width: 1)
//				Text("Second part Two")
//					.decidesWidthOf(vw, key: "COL2", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//				Divider()
//					.followsHeightOf(vw, key: "ROW2")
//					.frame(width: 1)
//				Text("Second part Three")
//					.decidesWidthOf(vw, key: "COL3", alignment: .leading)
//					.decidesHeightOf(vw, key: "ROW2")
//			}
//			.decidesWidthOf(vw, key: "WIDTH")
//		}
//
//	}
//}

struct Styling_Previews: PreviewProvider {
	static var previews: some View {
		Styling()
	}
}
