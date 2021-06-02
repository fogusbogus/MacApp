//
//  ContentView.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 03/08/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import SwiftUI
import UsefulExtensions

struct ContentView: View {
	
//	var tb = ContentView.getModel()
//
//	static func getModel() -> ToggleButtonModel {
//		let ret = ToggleButtonModel(text: "🟡")
//		ret.ExtraPadding = true
//		ret.font = .largeTitle
//		ret.DeselectedBackgroundColor = .blue
//		ret.DeselectedForegroundColor = .blue
//		ret.SelectedBackgroundColor = .yellow
//		ret.SelectedForegroundColor = .blue
//
//		return ret
//	}
	
	var body: some View {
		//ToggleButton(model: tb)
		//ReportScene()
		MainScreen_Splits(numOfSplits: 32)
	}
	
	/*
	Category: "A", JsonValue: "a", UpdateCategory: "A", Verbose: "a", IsToggle: true, IsActionButton: false, BorderColor: .black, DeselectedBackgroundColor: .gray, DeselectedForegroundColor: .lightText, SelectedBackgroundColor: .white, SelectedForegroundColor: .blue, text: "Push my button", ExtraPadding: true, font: .largeTitle
	*/
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		//ContentView()
		//MainScreen_Splits(numOfSplits: 32)
		
		Angina_MainScreen()
	}
}

class ToggleButtonModel : ObservableObject {
	
	var clickDelegate : ToggleButtonClickHandler?
	
	init(text: String) {
		self.text = text
	}
	
	var isCategorised : Bool {
		get {
			return !Category.isEmptyOrWhitespace()
		}
	}
	var Category = ""
	var JsonValue = ""
	var UpdateCategory = ""
	var Verbose = ""
	var IsToggle = false
	var IsActionButton = false
	var BorderColor = UIColor.opaqueSeparator
	var DeselectedBackgroundColor = UIColor.systemBackground
	var DeselectedForegroundColor = UIColor.label
	var SelectedBackgroundColor = UIColor.secondarySystemBackground
	var SelectedForegroundColor = UIColor.secondaryLabel
	var text = ""
	
	var ExtraPadding = true
	
	func backcolor() -> Color {
		if IsSelected {
			return SelectedBackgroundColor.toColor()
		}
		return DeselectedBackgroundColor.toColor()
	}
	func forecolor() -> Color {
		if IsSelected {
			return SelectedForegroundColor.toColor()
		}
		return DeselectedForegroundColor.toColor()
	}
	
	
	
	func extraPaddingLR() -> CGFloat {
		if ExtraPadding {
			return CGFloat(8)
		}
		return CGFloat(0)
	}
	func extraPaddingTB() -> CGFloat {
		if ExtraPadding {
			return CGFloat(4)
		}
		return CGFloat(0)
	}
	
	func toggle() {
		IsSelected = !IsSelected
	}

	@Published var IsSelected : Bool = false
	
	var font : Font = .body
}

protocol ToggleButtonClickHandler {
	func click(button: ToggleButtonModel)
}

struct ToggleButton: View {
	
	@ObservedObject var model : ToggleButtonModel
	
	var body: some View {
		Button(action: {
			self.model.toggle()
			self.model.clickDelegate?.click(button: self.model)
		}) {
			ZStack {
				//First draw the text to get the size
				Text(self.model.text)
					.font(self.model.font)
					.foregroundColor(self.model.forecolor())
					.padding([.leading, .trailing], self.model.extraPaddingLR())
					.padding([.top, .bottom], CGFloat(self.model.extraPaddingTB()))
					.overlay(
						ZStack {
							RoundedRectangle(cornerRadius: 20)
								.fill(self.model.backcolor())
							RoundedRectangle(cornerRadius: 20)
								.stroke(self.model.BorderColor.toColor(), lineWidth: 1)
							Text(self.model.text)
								.font(self.model.font)
								.foregroundColor(self.model.forecolor())
						}
				)
			}
		}
		
	}
}

extension UIColor {
	func toColor() -> Color {
		let clr = CIColor(color: self)
		return Color(.sRGB, red: Double(clr.red), green: Double(clr.green), blue: Double(clr.blue), opacity: Double(clr.alpha))
	}
}
