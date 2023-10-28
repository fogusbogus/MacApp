//
//  Variation+StoreCommand.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 12/10/2023.
//

import Foundation

extension StoreCommands {
	
	class Interval : StoreCommand {
		private(set) var interval: Int
		
		override init() {
			self.interval = 2
		}
		init(interval: Int) {
			self.interval = interval.clamped(to: 0...Int.max)
		}
		
		init(text: String) {
			self.interval = (Int(text) ?? 0).clamped(to: 0...Int.max)
		}
		
	}
}
