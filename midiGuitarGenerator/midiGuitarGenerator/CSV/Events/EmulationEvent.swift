//
//  EmulationEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	public class EmulationEvent: NonDataEvent {
		public override var type: Events.Types {
			get {
				return .emulation
			}
		}
		
		var is12String: Bool = false
		
		public init(is12String: Bool) {
			self.is12String = is12String
		}
	}
}

extension Events.EmulationEvent {
	enum ParseErrors: Error {
		case invalidEmulationValue(value: String)
	}
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.EmulationEvent? {
		if let value = Int(data[columns[.value]!]) {
			if ![6,12].contains(value) {
				throw ParseErrors.invalidEmulationValue(value: data[columns[.value]!])
			}
			return Events.EmulationEvent(is12String: value == 12)
		}
		throw ParseErrors.invalidEmulationValue(value: data[columns[.value]!])
	}
}

extension Events.EmulationEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "EMULATE \(is12String ? "12-string" : "6-string")"
	}
}

