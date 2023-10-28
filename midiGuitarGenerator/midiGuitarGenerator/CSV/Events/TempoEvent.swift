//
//  TempoEvent.swift
//  
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

extension Events {
	
	public class TempoEvent : TimelineEvent {
		public var type: Events.Types {
			get {
				return .tempo
			}
		}
		
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
}

extension Events.TempoEvent {
	enum ParseErrors: Error {
		case invalidTempoValue
	}
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.TempoEvent? {
		if let value = Float(data[columns[.value]!]) {
			if !(Float(32)...Float(255)).contains(value) {
				throw ParseErrors.invalidTempoValue
			}
			return Events.TempoEvent(value)
		}
		throw ParseErrors.invalidTempoValue
	}
}

extension Events.TempoEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "TEMPO \(tempo)"
	}
}
