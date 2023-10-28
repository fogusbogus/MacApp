//
//  Decay+StoreCommand.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 12/10/2023.
//

import Foundation

extension StoreCommands {
	class Decay : StoreCommand {
		private var decay: Events.DecayEvent
		
		override init() {
			self.decay = Events.DecayEvent(value: 0, isPercent: false)
		}
		init(decay: Events.DecayEvent) {
			self.decay = decay
		}
		
		init(text: String) {
			self.decay = Events.DecayEvent(text: text)
		}
		
		func generate(_ value: Float, iteration: Int = 1) -> Float {
			return decay.apply(value, iteration: iteration)
		}
	}
}
