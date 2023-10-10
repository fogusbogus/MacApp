//
//  Angina.Additional.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 03/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI



class AD_BloodPressure: AdditionalBase {
	
	var sys : String = "" {
		didSet {
			update.toggle()
		}
	}
	var dia : String = "" {
		didSet {
			update.toggle()
		}
	}
	var bpm : String = ""  {
		didSet {
			update.toggle()
		}
	}
	
	override func getSaveData() -> [String : Any] {
		var ret : [String:Any] = [:]
		if canUpdateBP {
			ret["sys"] = sys
			ret["dia"] = dia
		}
		if canUpdateBPM {
			ret["bpm"] = bpm
		}
		return collectSaveData("bp", data: ret)
	}
	
	var canUpdateBP : Bool {
		get {
			return Int(sys) != nil && Int(dia) != nil
		}
	}

	var canUpdateBPM : Bool {
		get {
			return Int(bpm) != nil
		}
	}

	override var canUpdate : Bool {
		get {
			return canUpdateBP || canUpdateBPM
		}
	}

	override func reset() {
		sys = ""
		dia = ""
		bpm = ""
	}
}

struct Angina_Additional: View {
	
	@State var points : PainPointModel
	@State var bpData : AD_BloodPressure
	@State var medData : AD_Medications
	@State var foodData : AD_Food
	@State var moodData : AD_Mood
	@State var notesData : AD_Notes
	
	func getAllSaveData() -> [String:Any] {
		return bpData.getSaveData() + medData.getSaveData() + foodData.getSaveData() + moodData.getSaveData() + notesData.getSaveData()
	}
	
	var standardButtonSize: CGFloat = 48
	
    var body: some View {
		VStack {
			ScrollView(.vertical, showsIndicators: true, content: {
				VStack(spacing: 48) {
					BloodPressure(data: bpData)
					Medications(data: medData)
					Food(data: foodData)
					Mood(data: moodData)
					Notes(data: notesData)
				}
			})
			Spacer()
			HStack {
				Spacer()
				Button (action: {
					bpData.reset()
					medData.reset()
					foodData.reset()
					moodData.reset()
					notesData.reset()
				}) {
					Image(systemName: "square.and.arrow.down")
						.resizable()
						.frame(width: standardButtonSize, height: standardButtonSize, alignment: .center)
						.foregroundColor(.green)
						.onTapGesture {
							print(getAllSaveData())
							bpData.reset()
							medData.reset()
							foodData.reset()
							moodData.reset()
							notesData.reset()
						}
						//.shadow(color: .black, radius: 4)
				}
				Spacer()
				Spacer()
				Spacer()
				
				AnginaButton(systemName: "return", iconSize: standardButtonSize, fgColor: .white, bgColor: .red, offset: CGSize.zero, shadow: .black, shadowSize: standardButtonSize, tapAction: {
					print(getAllSaveData())
								points.goBack()
					
				})
				
				
				Spacer()
			}
		}
    }
}

struct BloodPressure: View {
	
	@ObservedObject var data : AD_BloodPressure
	
	var body: some View {
		VStack(spacing: 24) {
			Headline(text: "Blood Pressure")
			HStack {
				TextField("Sys", text: $data.sys)
					.frame(width: 48)
					.keyboardType(.numberPad)
					
				Text("/")
				TextField("Dia", text: $data.dia)
					.frame(width: 48)
					.keyboardType(.numberPad)
				Text("❤️")
				TextField("BPM", text: $data.bpm)
					.frame(width: 48)
					.keyboardType(.numberPad)
				Spacer()
			}
			.padding([.leading, .trailing], 48)
			UpdateLine(action: {
				print(data.getSaveData())
				data.reset()
			}, allowed: data.canUpdate)
		}
	}
}

struct GlowButton : View {
	
	var text: String
	var action: () -> Void
	var allowed: Bool
	
	func bgColor() -> Color {
		var ret : Color = .white
		if allowed {
			ret = .blue
		}
		return ret
	}
	
	func fgColor() -> Color {
		var ret : Color = .blue
		if allowed {
			ret = .white
		}
		return ret
	}
	var body : some View {
		Button(action: {
			action()
		}) {
			Text(text)
				.foregroundColor(fgColor())
				.padding([.leading, .trailing], 8)
				.background(bgColor())
				.cornerRadius(14)
				.overlay(
					RoundedRectangle(cornerRadius: 14)
						.strokeBorder()
				)
				.shadow(color: .blue, radius: 5, x: 0.0, y: 0.0)
			//.border(Color.blue, width: 1)
		}
	}
}

struct UpdateLine : View {
	
	var action: () -> Void
	var allowed: Bool

	func bgColor() -> Color {
		var ret : Color = .white
		if allowed {
			ret = .blue
		}
		return ret
	}
	
	func fgColor() -> Color {
		var ret : Color = .blue
		if allowed {
			ret = .white
		}
		return ret
	}
	
	var body: some View {
		HStack {
			Spacer()
			Button(action: {
				action()
			}) {
				Text("Update")
					.foregroundColor(fgColor())
					.padding([.leading, .trailing], 8)
					.background(bgColor())
					.cornerRadius(14)
					.overlay(
						RoundedRectangle(cornerRadius: 14)
							.strokeBorder()
					)
					.shadow(color: .blue, radius: 5, x: 0.0, y: 0.0)
					//.border(Color.blue, width: 1)
			}
		}
		.padding(.trailing, 24)
	}
}

struct Angina_Additional_Previews: PreviewProvider {

	static var points =  PainPointModel()

	static var bp : AD_BloodPressure = AD_BloodPressure()
	static var meds = AD_Medications()
	static var food = AD_Food()
	static var mood = AD_Mood()
	static var notes = AD_Notes()
	
	static var previews: some View {
		Angina_Additional(points: points, bpData: bp, medData: meds, foodData: food, moodData: mood, notesData: notes)
    }
}
