//
//  Keyboard.swift
//  Wordle
//
//  Created by Matt Hogg on 12/03/2022.
//

import SwiftUI

struct Keyboard: KeyboardKeyPressHandler, View {
	
	var demoMode: Bool = false
	
	@State private var text = ""
	
	func keyPressed(key: String) {
		print(key)
		if demoMode {
			text = text + key
		}
	}
	
    var body: some View {
		VStack(spacing: 8) {
			if demoMode {
				Text(text)
			}
			RowOfKeys(keys: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"], keyHandler: self)
			RowOfKeys(keys: ["A", "S", "D", "F", "G", "H", "J", "K", "L"], keyHandler: self)
			RowOfKeys(keys: ["Z", "X", "C", "V", "B", "N", "M"], keyHandler: self)
		}
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
		Keyboard(demoMode: true)
    }
}

struct RowOfKeys: View {
	var keys: [String]
	
	var keyHandler: KeyboardKeyPressHandler? = nil
	
	var body: some View {
		HStack(spacing: 8) {
			ForEach(keys, id:\.self) { key in
				Button {
					keyHandler?.keyPressed(key: key)
				} label: {
					Text(key)
						.frame(width:24, height:24)
						.border(.primary, width: 1)
				}
			}
		}
	}
}

protocol KeyboardKeyPressHandler {
	func keyPressed(key: String)
}
