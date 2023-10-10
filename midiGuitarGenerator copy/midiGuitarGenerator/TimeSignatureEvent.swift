//
//  TimeSignatureEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

open class TimeSignatureEvent : TimelineEvent {
	public var uniqueToDelta: Bool = true
	public var id: UUID = UUID()
	
	public func toMIDIData(channel: Int = 0) -> [UInt8] {
		var ret: [UInt8] = [0xff, 0x58, 0x04]
		ret.append(UInt8(numerator))
		switch denominator {
			case 1:
				ret.append(0)
			case 2:
				ret.append(1)
			case 4:
				ret.append(2)
			case 8:
				ret.append(3)
			case 16:
				ret.append(4)
			case 32:
				ret.append(5)
			case 64:
				ret.append(6)
			case 128:
				ret.append(7)
			default:
				ret.append(8)
		}
		ret.append(contentsOf: [0x24, 0x08])
		return ret
	}
	
	private(set) var numerator: Int
	private(set) var denominator: Int
	
	enum Errors: Error {
		case invalidDenominator, invalidNumerator, invalidDefinition
	}
	
	init(numerator: Int, denominator: Int) throws {
		guard numerator > 0 else { throw Errors.invalidNumerator }
		guard [1,2,4,8,16,32,64,128].contains(denominator) else { throw Errors.invalidDenominator }
		self.numerator = numerator
		self.denominator = denominator
	}
	
	init(timeSignature: String) throws {
		guard timeSignature.contains("/") else { throw Errors.invalidDefinition }
		let nums = timeSignature.split(separator: "/").compactMap {Int($0)}
		if nums.count < 2 {
			throw Errors.invalidDefinition
		}
		if nums.first! < 1 {
			throw Errors.invalidNumerator
		}
		if ![1,2,4,8,16,32,64,128].contains(nums[1]) {
			throw Errors.invalidDenominator
		}
		self.numerator = nums[0]
		self.denominator = nums[1]
	}
	
	func ticksPerDenominator(_ ticksPerCrotchet: Int = 96) -> Int {
		//4 = 96, 8 = 96 / 2, 16 = 96 / 4, 2 = 96 * 2, 1 = 96 * 4
		switch denominator {
			case 128:
				return ticksPerCrotchet / 32
			case 64:
				return ticksPerCrotchet / 16
			case 32:
				return ticksPerCrotchet / 8
			case 16:
				return ticksPerCrotchet / 4
			case 8:
				return ticksPerCrotchet / 2
			case 4:
				return ticksPerCrotchet
			case 2:
				return ticksPerCrotchet * 2
			case 1:
				return ticksPerCrotchet * 4
			default:
				return ticksPerCrotchet
		}
	}
	
	private func getBarOffsetTicks(numerator: Float, _ ticksPerCrotchet: Int = 96) -> Int {
		return Int(Float(ticksPerDenominator(ticksPerCrotchet)) * numerator)
	}
	
	func ticksPerBar(_ ticksPerCrotchet: Int = 96) -> Int {
		return getBarOffsetTicks(numerator: Float(numerator), ticksPerCrotchet)
	}
}
