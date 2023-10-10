//
//  Angina.Additional.Mood.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 04/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI

class AD_Mood : AdditionalBase {
	
	var value : Float = 0.5 {
		didSet {
			hasChanged = true
			update.toggle()
		}
	}
	
	var feeling : String = "" {
		didSet {
			if feeling.trim().length() > 0 {
				hasChanged = true
			}
			update.toggle()
		}
	}
	
	var hasChanged : Bool = false
	
	override var canUpdate: Bool {
		get {
			return hasChanged
		}
	}
	
	override func reset() {
		value = 0.5
		feeling = ""
		hasChanged = false
	}
	
	override func getSaveData() -> [String : Any] {
		var ret : [String:Any] = ["value":value]
		if feeling.trim().length() > 0 {
			ret["feeling"] = feeling.trim()
		}
		return collectSaveData("mood", data: ret)
	}

}

struct Mood: View {
	
	@ObservedObject var data : AD_Mood
	
	var body : some View {
		VStack(spacing: 24) {
			Headline(text: "Mood", minHeight: CGFloat(24))
			HStack(spacing: 24) {
				Text("☹️")
				Slider(value: $data.value, in: 0...1) { (changed) in
					
				}
				Text("🙂")
			}
			.padding([.leading, .trailing], 24)
			TextField("How are you feeling?", text: $data.feeling)
			.padding([.leading, .trailing], 24)
			UpdateLine(action: {
				print(data.getSaveData())
				data.reset()
			}, allowed: data.canUpdate)
		}
	}
}

struct Angina_Additional_Mood: View {
	@State var data = AD_Mood()
	var body: some View {
		Mood(data: data)
	}
}

struct Angina_Additional_Mood_Previews: PreviewProvider {
	static var previews: some View {
		Angina_Additional_Mood()
	}
}
