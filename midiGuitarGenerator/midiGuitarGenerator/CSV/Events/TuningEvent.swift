//
//  TuningEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	public class TuningEvent: NonDataEvent {
		public override var type: Events.Types {
			get {
				return .tuning
			}
		}
		
		var notes: [Int] = [40,45,50,55,59,64, 52,57,62,67,59,64]
		
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
}

extension Events.TuningEvent {
	enum ParseErrors: Error {
		case invalidMIDINoteValue(value: Int), missingColumn
	}
	
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.TuningEvent? {
		if !columns.keys.containsAll([.v1, .v2, .v3, .v4, .v5, .v6]) {
			throw ParseErrors.missingColumn
		}
		var tunings : [Int] = [
			Int(data[columns[.v1]!]) ?? 0,
			Int(data[columns[.v2]!]) ?? 0,
			Int(data[columns[.v3]!]) ?? 0,
			Int(data[columns[.v4]!]) ?? 0,
			Int(data[columns[.v5]!]) ?? 0,
			Int(data[columns[.v6]!]) ?? 0
		]
		
		if tunings.contains(where: {$0 < 0 || $0 > 115}) {
			throw ParseErrors.invalidMIDINoteValue(value: tunings.first(where: {$0 < 0 || $0 > 115})!)
		}
		
		//Default 12-string offsets - this may be changeable in the future
		//FUTURE: Make all 12-strings re-assignable
		tunings.append(tunings[0] + 12)
		tunings.append(tunings[1] + 12)
		tunings.append(tunings[2] + 12)
		tunings.append(tunings[3] + 12)
		tunings.append(tunings[4])
		tunings.append(tunings[5])
		
		return Events.TuningEvent(notes: tunings)
	}
}


extension Events.TuningEvent: Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "Tuning (\(notes.map {$0.toMIDINote()}.joined(separator: ", ")))"
	}
}
