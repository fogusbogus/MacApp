//
//  DecayEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	
	public class DecayEvent : NonDataEvent {
		public override var type: Events.Types {
			get {
				return .decay
			}
		}
		
		var value: Float
		var isPercent: Bool
		
		public init(value: Float, isPercent: Bool) {
			self.value = value
			self.isPercent = isPercent
		}
		
		public init(text: String) {
			self.isPercent = text.contains("%")
			self.value = Float(text.keepNumeric()) ?? 0
		}
		
		public func apply(_ floatValue: Float, iteration: Int) -> Float {
			guard iteration > 0 else { return floatValue }
			guard value > 0 else { return floatValue }
			var ret = floatValue
			let pc : Float = 1.0 - (value / 100.0)
			(0..<iteration).forEach { _ in
				if isPercent {
					ret *= pc
				}
				else {
					ret -= value
				}
			}
			return ret
		}
	}
	
}

extension Events.DecayEvent {
	enum ParseErrors: Error {
		case invalidDecayValue(value: String)
	}
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.DecayEvent? {
		let text = data[columns[.value]!]
		if let value = Float(text.keepNumeric()) {
			let isPercent = text.contains("%")
			if !isPercent && !(Float(32)...Float(255)).contains(value) {
				throw ParseErrors.invalidDecayValue(value: data[columns[.value]!])
			}
			if isPercent && !(Float(0)...Float(100)).contains(value) {
				throw ParseErrors.invalidDecayValue(value: data[columns[.value]!])
			}
			return Events.DecayEvent(text: text)
		}
		throw ParseErrors.invalidDecayValue(value: data[columns[.value]!])
	}
}

extension Events.DecayEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "DECAY \(value)\(isPercent ? "%" : "")"
	}
}

extension Events.DecayEvent : Friendly {
	func friendlyDescription() -> String {
		return "Decay of \(value)\(isPercent ? "%": " ticks")"
	}
}
