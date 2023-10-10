//
//  Extensions.swift
//  
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

extension Comparable {
	func clamped(to limits: ClosedRange<Self>?) -> Self {
		guard let limits = limits else { return self }
		return min(max(self, limits.lowerBound), limits.upperBound)
	}
}

extension Int {
	func asMIDIVelocity() -> Int {
		return self.clamped(to: 0...127)
	}
	
	func withVariation(range: ClosedRange<Float> = 0...0, percent: Bool = false) -> Int {
		if !percent {
			return Int(Float(self) + Float.random(in: range))
		}
		let fltRange = (range.lowerBound / 100.0)...(range.upperBound / 100.0)
		let ret = Float(self) + Float(self) * Float.random(in: fltRange)
		return Int(ret)
	}
}

extension Float {
	func asMIDIVelocity() -> Float {
		return self.clamped(to: 0...127)
	}
	
	func withVariation(range: ClosedRange<Float> = 0...0, percent: Bool = false) -> Float {
		if !percent {
			return self + Float.random(in: range)
		}
		let fltRange = (range.lowerBound / 100.0)...(range.upperBound / 100.0)
		let ret = Float(self) + Float(self) * Float.random(in: fltRange)
		return ret
	}
}

extension Int {
	func getBytes(_ length: Int = 4) -> [UInt8] {
		var ret : [UInt8] = []
		var length = length
		var me = self
		while length > 0 {
			ret.insert(UInt8(me % 256), at: 0)
			me /= 256
			length -= 1
		}
		return ret
	}
	
	
	func getDeltaBytes() -> [UInt8] {
		var delta = self
		var buffer: UInt64 = UInt64(delta % 128)
		delta = delta >> 7
		while delta > 0 {
			buffer = buffer << 8
			buffer = buffer | UInt64(128)
			buffer += UInt64(delta % 128)
			delta = delta >> 7
		}
		
		var ret: [UInt8] = []
		while true {
			ret.append(UInt8(buffer % 256))
			if (buffer & 128) > 0 {
				buffer = buffer >> 8
			}
			else {
				break
			}
		}
		return ret
	}
}

extension String {
	func keepNumeric() -> String {
		let symbols = Array("1234567890") + Array(Locale.current.decimalSeparator ?? "")
		return String(Array(self).filter {symbols.contains($0)})
	}
	
	public func getMask() -> [Bool] {
		var ret = Array(self.trimmingCharacters(in: .whitespacesAndNewlines)).map {!"Xx".contains($0)}
		while ret.count < 6 {
			ret.append(false)
		}
		while ret.count > 6 {
			ret.removeLast()
		}
		return ret
	}
}
