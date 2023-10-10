//
//  TimeCode.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

/*
 Translate a timecode into a delta and vice-versa
 
 A timecode is made up of 3 parts. A bar number, the numerator number and a fractional (or delta offset).
 
 e.g. B:N:D
 
 Here, the colon can be interchangeable with a decimal point
 
 The lowest timecode is: 1:1:0
 
 The bars start at position 1, numerators start at one and deltas start at zero
 
 For the MIDI output we are using 96 ticks per Crotchet (a 4 denominator in a time signature)
 
 Our range in values for the first bar is:
 
 B : 1
 N : 1 - 4
 D: 0-95
 
 So for the timecode of 1:1:95 the next smallest timecode is 1:2:0
 The maximum timecode is 1:4:95 after this comes 2:1:0
 */

open class TimeCode {
	static func translateToDelta(_ timecode: String, timeline: Timeline? = nil) -> Int {
		let timeline = timeline ?? Timeline()
		let tc = translateToBND(timecode)
		let info = timeline.getBarInfo(tc.bar - 1)
		var delta = info.delta
		delta += (tc.numerator - 1) * info.denominatorLength
		delta += tc.delta
		return delta
	}
	
	static func translateToTimeCode(_ delta: Int, timeline: Timeline? = nil) -> String {
		let timeline = timeline ?? Timeline()
		let barNo = timeline.getBarNoFromDelta(delta)
		let info = timeline.getBarInfo(barNo)
		let delta = delta - info.delta
		let numerator = 1 + delta / info.denominatorLength
		let remaining = delta % info.denominatorLength
		return "\(barNo + 1):\(numerator):\(remaining)"
	}
	
	static func translateToBND(_ timecode: String, lastTimeCode: String = "") -> (bar: Int, numerator: Int, delta: Int) {
		var nums: [String] = []
		var current: String = ""
		timecode.forEach { c in
			if c.isNumber {
				current += "\(c)"
			}
			else {
				if current.count > 0 {
					nums.append(current)
				}
				current = ""
			}
		}
		if current.count > 0 {
			nums.append(current)
		}
		nums.reverse()
		nums.append(contentsOf: ["0","0","0"])
		if timecode.contains("+") && !lastTimeCode.isEmpty {
			//This is an offset
			var last = translateToBND(lastTimeCode.replacingOccurrences(of: "+", with: ""))
			last.numerator += Int(nums[1]) ?? 0
			last.delta += Int(nums[0]) ?? 0
			return (bar: Int(nums[2]) ?? 0, numerator: last.numerator, delta: last.delta)
		}
		return (bar: Int(nums[2]) ?? 0, numerator: Int(nums[1]) ?? 0, delta: Int(nums[0]) ?? 0)
	}
}
