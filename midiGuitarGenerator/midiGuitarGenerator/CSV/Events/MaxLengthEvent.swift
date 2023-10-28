//
//  MaxLengthEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 22/10/2023.
//

import Foundation

extension Events {
	public class MaxLengthEvent : NonDataEvent {
		public override var type: Events.Types {
			get {
				return .maxLength
			}
		}
		
		public var value: Int = 3000
		public var alignEnd: Bool = false
		
		init(value: Int, alignEnd: Bool) {
			self.value = value
		}
		init(text: String) {
			self.alignEnd = text.contains("|")
			self.value = Int(text.keepNumeric()) ?? 3000
		}
		
		public static func getPreferredValue(delta: Int, timeline: Timeline? = nil, value: Int) -> MaxLengthEvent {
			guard let timeline = timeline else { return MaxLengthEvent(text: "3000") }
			let last = timeline.getLastInstanceOf(delta, defaultValue: MaxLengthEvent(value: 3000, alignEnd: false))!
			return last
		}
	}
}

extension Events.MaxLengthEvent {
	
	enum ParseErrors : Error {
		case invalidMaxLength(value: String)
	}
	
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.MaxLengthEvent? {
		let text = data[columns[.value]!]
		if let value = Int(text.keepNumeric()) {
			if value < 1 {
				throw ParseErrors.invalidMaxLength(value: text)
			}
		}
		else {
			throw ParseErrors.invalidMaxLength(value: text)
		}
		return Events.MaxLengthEvent(text: text)
	}
}


extension Events.MaxLengthEvent: Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "MAXLENGTH \(value)"
	}
}
