//
//  TempoEvent.swift
//  
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

public class TempoEvent : TimelineEvent {
	public var uniqueToDelta: Bool = true
	public var id: UUID = UUID()
	
	public func toMIDIData(channel: Int = 0) -> [UInt8] {
		var ret: [UInt8] = [0xff, 0x51, 3]
		let byteTempo = Int(60000000.0 / tempo)
		ret.append(contentsOf: byteTempo.getBytes(3))
		return ret
	}

	var tempo: Float = 120.0
	
	public init(_ tempo: Float) {
		self.tempo = tempo
	}
}
