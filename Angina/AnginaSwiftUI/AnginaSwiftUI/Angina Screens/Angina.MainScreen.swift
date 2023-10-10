//
//  Angina.MainScreen.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 27/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI



struct Angina_MainScreen: View {
	
	@ObservedObject var points = PainPointModel()
	
	@State var bpData : AD_BloodPressure = AD_BloodPressure()
	@State var medData = AD_Medications()
	@State var foodData = AD_Food()
	@State var moodData = AD_Mood()
	@State var notesData = AD_Notes()
	
	func reportButtonLocation(size: CGSize) -> CGSize {
		let iwh = size.width * ICONMULT
		let d = size.width / 6
		let w = 1.5 * d - (iwh / 2)
		let h = size.height * 0.8
		return CGSize(width: w, height: h)
	}

	func saveButtonLocation(size: CGSize) -> CGSize {
		let iwh = size.width * ICONMULT
		let d = size.width / 6
		let w = 3 * d - (iwh / 2)
		let h = size.height * 0.8
		return CGSize(width: w, height: h)
	}
	
	func specialButtonLocation(size: CGSize) -> CGSize {
		let iwh = size.width * ICONMULT
		let d = size.width / 6
		let w = 4.5 * d - (iwh / 2)
		let h = size.height * 0.8
		return CGSize(width: w, height: h)
	}

	private let ICONMULT = CGFloat(0.125)
	
	func shadowSize(size: CGSize) -> CGFloat {
		return CGFloat(0.6 * (size.width * ICONMULT))
	}

    var body: some View {
		if points.currentPage == "" {
			ZStack {
				GeometryReader { geo in
					Image("MainBackground")
						.resizable()
						.aspectRatio(contentMode: ContentMode.fit)
					ForEach(0..<points.points.count, id: \.self) {
						idx in
						let pt = points.points[idx]
						PainButton(painPoint: $points.points[idx], size: Int(geo.size.width * 0.05))
							.offset(x: CGFloat(CGFloat(pt.x) * geo.size.width), y: CGFloat(CGFloat(pt.y) * geo.size.width))
					}
					
					AnginaButton(systemName: "doc.circle.fill", iconSize: CGFloat(geo.size.width * ICONMULT), fgColor: .green, bgColor: .white, offset: reportButtonLocation(size: geo.size), shadow: .black, shadowSize: shadowSize(size: geo.size), tapAction: {
						points.page.append("report")
					})
					
					AnginaButton(systemName: "checkmark.circle.fill", iconSize: CGFloat(geo.size.width * ICONMULT), fgColor: points.PainPointsSelected().count > 0 ? Color.red : Color.gray, bgColor: .white, offset: saveButtonLocation(size: geo.size), shadow: .black, shadowSize: shadowSize(size: geo.size), tapAction: {
						points.action = "save"
					})
					
					AnginaButton(systemName: "plus.app.fill", iconSize: CGFloat(geo.size.width * ICONMULT), fgColor: .blue, bgColor: .white, offset: specialButtonLocation(size: geo.size), shadow: .black, shadowSize: shadowSize(size: geo.size), tapAction: {
						points.page.append("extra")
					})
					
				}
			}
		}
		else if points.currentPage == "report" {
			ReportScene(points: points)
		} else if points.currentPage == "extra" {
			Angina_Additional(points: points, bpData: bpData, medData: medData, foodData: foodData, moodData: moodData, notesData: notesData)
		}
    }
}

struct AnginaButton : View {
	
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

struct Angina_MainScreen_Previews: PreviewProvider {
    static var previews: some View {
		ZStack {
			Spacer()
				.background(Color.gray)
				.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			Group {
				Angina_MainScreen()
					.background(Color.gray)
			}
		}
	}
}
