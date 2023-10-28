//
//  Variation+StoreCommand.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 12/10/2023.
//

import Foundation

extension StoreCommands {
	class Variation : StoreCommand {
		private var variation: Events.VariationEvent
		
		override init() {
			self.variation = Events.VariationEvent(range: 0...0, isPercent: false)
		}
		init(variation: Events.VariationEvent) {
			self.variation = variation
		}
		
		init(text: String) {
			self.variation = Events.VariationEvent(text: text)
		}
		
		func generate(_ value: Float, rangeLimit: ClosedRange<Float>? = nil) -> Float {
			return variation.generate(value: value, rangeLimit: rangeLimit)
		}
	}
}
