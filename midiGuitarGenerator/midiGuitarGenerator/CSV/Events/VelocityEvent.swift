//
//  VelocityEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 20/10/2023.
//

import Foundation

extension Events {
	public class VelocityEvent: NonDataEvent {
		public override var type: Events.Types {
			get {
				return .velocity
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
		
		public func getMIDIValue(position: Int = 0, timeline: Timeline? = nil) -> Int {
			let variation = timeline?.getLastInstanceOf(position, defaultValue: VariationEvent(text: "100%"))!
			let startingValue = (variation?.generate(value: 127.0, rangeLimit: 0...127))!
			if isPercent {
				let ret = Double(startingValue) * (Double(value) / 100.0)
				return Int(ret).clamped(to: 0...127)
			}
			return Int(value).clamped(to: 0...127)
		}
		
		
		public static func getPreferredValue(delta: Int, timeline: Timeline? = nil, value: Int) -> Int {
			guard let timeline = timeline else { return value }
			
			let last = timeline.getLastInstanceOf(delta, defaultValue: VelocityEvent(value: 127, isPercent: false))!
			return last.getMIDIValue(position: delta, timeline: timeline)
		}

	}
}


extension Events.VelocityEvent: Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "VELOCITY \(value)\(isPercent ? "%": "")"
	}
}
