//
//  StrumVariationEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	public class StrumVariationEvent : NonDataEvent {
		public override var type: Events.Types {
			get {
				return .strumVariation
			}
		}
		
		var value: Float {
			didSet {
				if value < 0 {
					isOff = true
				}
			}
		}
		var isPercent: Bool = false
		var isOff: Bool = false
		
		public init(value: Float, isPercent: Bool) {
			self.value = value
			self.isPercent = isPercent
		}
		
		public init(text: String) {
			self.isPercent = text.contains("%")
			self.isOff = text.localizedCaseInsensitiveCompare("OFF") == .orderedSame
			self.value = Float(text.keepNumeric()) ?? -1
		}
		
		private func generateVelocity() -> Int {
			guard !isOff else { return 0 }
			guard value > 0 else { return 0 }
			if isPercent {
				return Int(127.0 * (1 - Double(value) / 100.0)).clamped(to: 1...127)
			}
			return Int(value).clamped(to: 1...127)
		}
		
		public func getVelocities(chord: Chord, timeline: Timeline, position: Int, mask: String, direction: Direction = .down) -> [Int] {
			
			let velocity = generateVelocity()
			let variation = timeline.getLastInstanceOf(position, defaultValue: Events.VariationEvent(range: -4...4, isPercent: false))
			let decay = timeline.getLastInstanceOf(position, defaultValue: Events.DecayEvent(value: 4.0, isPercent: true))
			var newVelocity = variation?.generate(value: Float(velocity), rangeLimit: 1...127)
			if velocity == 0 {
				newVelocity = 0
			}
			let maskBool = mask.getMask()
			var start = Int(maskBool.firstIndex(of: true)?.description ?? "") ?? -1
			var end = Int(maskBool.lastIndex(of: true)?.description ?? "") ?? -1
			let mistrikeEvent = timeline.getLastInstanceOf(position, defaultValue: Events.StrumMistrikeEvent(start: 0, end: 0))!
			let newStartEnd = mistrikeEvent.generate(start: start, end: end)
			start = newStartEnd.start
			end = newStartEnd.end
			var velocities : [Int] = [-1,-1,-1,-1,-1,-1]
			(start...end).forEach { stringNo in
				let iteration = direction == .down ? stringNo - start : end - stringNo
				let newVel = decay!.apply(newVelocity!, iteration: iteration)
				velocities[stringNo] = Int(newVel)
			}
			return velocities
		}
	}
}

extension Events.StrumVariationEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "STRUMVAR \(isOff ? "OFF" : "\(value)\(isPercent ? "%": "")")"
	}
}
