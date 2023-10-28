//
//  VariationEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	public class VariationEvent : NonDataEvent {
		public override var type: Events.Types {
			get {
				return .variation
			}
		}
		
		var range: ClosedRange<Float>
		var isPercent: Bool
		
		public init(range: ClosedRange<Float>, isPercent: Bool) {
			self.range = range
			self.isPercent = isPercent
		}
		
		init(text: String) {
			if text.keepNumeric().isEmpty {
				self.range = 0...0
				self.isPercent = false
			}
			else {
				let value : Float = Float(text.keepNumeric()) ?? 0
				var lower = value, higher = value
				if text.contains("-") {
					lower = -value
					// if we have no upper range, assume zero
					if !text.contains("+") {
						higher = 0
					}
				}
				else {
					// no lower range created, so assume zero
					lower = 0
				}
				self.isPercent = text.contains("%")
				self.range = lower...higher
			}
		}
		
		func generate(value: Float, rangeLimit: ClosedRange<Float>? = nil) -> Float {
			if isPercent {
				let myRange = Float(1.0 + Float(range.lowerBound) / 100.0)...Float(1.0 + Float(range.upperBound) / 100.0)
				let random = Float.random(in: myRange)
				return (Float(value) * random).clamped(to: rangeLimit)
			}
			let newValue = Float(value) + Float.random(in: range)
			if let rangeLimit = rangeLimit {
				return newValue.clamped(to: rangeLimit)
			}
			return newValue
		}
		
	}

}

extension Events.VariationEvent {
	
	enum ParseErrors : Error {
		case invalidVariationValue(value: String)
	}
	
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.VariationEvent? {
		let text = data[columns[.value]!]
		
		return Events.VariationEvent(text: text)
	}
}


extension Events.VariationEvent: Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "VARIATION \(range.lowerBound)...\(range.upperBound)\(isPercent ? "%": "")"
	}
}
