//
//  Angina.Additional.Notes.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 04/01/2021.
//  Copyright © 2021 Matt Hogg. All rights reserved.
//

import SwiftUI

class AD_Notes : AdditionalBase {
	
	var value : String = "" {
		didSet {
			update.toggle()
		}
	}
	
	override var canUpdate: Bool {
		get {
			return value.trim().length() > 0
		}
	}
	
	override func reset() {
		value = ""
	}

	override func getSaveData() -> [String : Any] {
		if canUpdate {
			return collectSaveData("notes", data: ["value":value])
		}
		return [:]
	}
}

struct Notes: View {
	
	@ObservedObject var data : AD_Notes
	
	var body : some View {
		VStack(spacing: 24) {
			Headline(text: "Notes")

			TextField("Additional notes", text: $data.value)
				.padding([.leading, .trailing], 24)
			UpdateLine(action: {
				print(data.getSaveData())
				data.reset()
			}, allowed: data.canUpdate)
		}
	}
}

struct Angina_Additional_Notes: View {
	@State var data = AD_Notes()
	var body: some View {
		Notes(data: data)
	}
}

struct Angina_Additional_Notes_Previews: PreviewProvider {
	static var previews: some View {
		Angina_Additional_Notes()
	}
}
