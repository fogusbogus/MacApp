//
//  IntervalEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 20/10/2023.
//

import Foundation

extension Events {
	public class IntervalEvent : NonDataEvent {
		public override var type: Events.Types {
			get {
				return .interval
			}
		}
		
		public var value: Int = 2
		
		init(value: Int) {
			self.value = value
		}
		
		public static func getPreferredValue(delta: Int, timeline: Timeline? = nil, value: Int) -> Int {
			guard let timeline = timeline else { return value }
			let last = timeline.getLastInstanceOf(delta, defaultValue: IntervalEvent(value: 2))!
			return last.value.clamped(to: 0...Int.max)
		}
	}
}


extension Events.IntervalEvent: Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "INTERVAL \(value)"
	}
}
