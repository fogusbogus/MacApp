//
//  Variation+StoreCommand.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 12/10/2023.
//

import Foundation

extension StoreCommands {
	
	class StrumVelocity : StoreCommand {
		private(set) var velocity: Int
		
		override init() {
			self.velocity = 127
		}
		init(velocity: Int) {
			self.velocity = velocity.clamped(to: 0...127)
		}
		
		init(text: String) {
			if text.contains("%") {
				let pc = (Double(text.keepNumeric()) ?? 0) / 100.0
				self.velocity = Int(127.0 * pc).clamped(to: 0...127)
			}
			else {
				self.velocity = (Int(text.keepNumeric()) ?? 0).clamped(to: 0...127)
			}
		}
		
	}
	
}
