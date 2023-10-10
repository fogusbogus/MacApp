//
//  NonDataEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

public class NonDataEvent : TimelineEvent {
	public var id: UUID = UUID()
	
	public func toMIDIData(channel: Int) -> [UInt8] {
		return []
	}
	
	public var uniqueToDelta: Bool = true
}

/// Allows a strum definition without having to provide velocities
public class StrumVariationEvent : NonDataEvent {
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
		let variation = timeline.getLastInstanceOf(position, defaultValue: VariationEvent(range: -4...4, isPercent: false))
		let decay = timeline.getLastInstanceOf(position, defaultValue: DecayEvent(value: 4.0, isPercent: true))
		var newVelocity = variation?.generate(value: Float(velocity), rangeLimit: 1...127)
		if velocity == 0 {
			newVelocity = 0
		}
		let maskBool = mask.getMask()
		var start = Int(maskBool.firstIndex(of: true)?.description ?? "") ?? -1
		var end = Int(maskBool.lastIndex(of: true)?.description ?? "") ?? -1
		let mistrikeEvent = timeline.getLastInstanceOf(position, defaultValue: StrumMistrike_Event(start: 0, end: 0))!
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

public class StrumMistrike_Event: NonDataEvent {
	var stringCountStart: Int = 0 {
		didSet {
			if !(0...6).contains(stringCountStart) {
				stringCountStart = stringCountStart.clamped(to: 0...6)
			}
		}
	}
	var stringCountEnd: Int = 0 {
		didSet {
			if !(0...6).contains(stringCountEnd) {
				stringCountEnd = stringCountEnd.clamped(to: 0...6)
			}
		}
	}
	
	public init(start: Int, end: Int) {
		self.stringCountStart = start
		self.stringCountEnd = end
	}
	
	func generate(start: Int, end: Int) -> (start: Int, end: Int) {
		let offStart = Int.random(in: 0...stringCountStart)
		let offEnd = Int.random(in: 0...stringCountEnd)
		let start = start + offStart
		let end = end - offEnd
		if end < start {
			return (start: end, end: start)
		}
		return (start: start, end: end)
	}
}

public class DecayEvent : NonDataEvent {
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

public class VariationEvent : NonDataEvent {
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
			let myRange = Float(1.0 - Float(range.lowerBound) / 100.0)...Float(1.0 + Float(range.upperBound) / 100.0)
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

public class Tuning: NonDataEvent {
	var notes: [Int] = [28,33,38,43,47,52, 40,45,50,55,47,52]
	
	override init() {
		super.init()
	}
	public init(notes: [Int]) {
		self.notes = notes
		while self.notes.count < 12 {
			self.notes.append(0)
		}
	}
}

public class Emulation: NonDataEvent {
	var is12String: Bool = false
	
	public init(is12String: Bool) {
		self.is12String = is12String
	}
}
