//
//  StrumMistrikeEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension Events {
	public class StrumMistrikeEvent: NonDataEvent {
		public override var type: Events.Types {
			get {
				return .strumMistrike
			}
		}
		
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
}

extension Events.StrumMistrikeEvent {
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.StrumMistrikeEvent? {
		return Events.StrumMistrikeEvent(start: 1, end: 1)
	}
}

extension Events.StrumMistrikeEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "MISTRIKE \(stringCountStart)...\(stringCountEnd)"
	}
}
