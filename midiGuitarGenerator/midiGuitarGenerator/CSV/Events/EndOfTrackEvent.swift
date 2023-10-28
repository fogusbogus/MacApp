//
//  EndOfTrackEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

extension Events {
	class EndOfTrackEvent : TimelineEvent {
		var type: Events.Types {
			get {
				return .endOfTrack
			}
		}
		
		var id: UUID = UUID()
		
		func toMIDIData(channel: Int) -> [UInt8] {
			return [255, 0x2f, 0]
		}
		
		var uniqueToDelta: Bool = true
	}
}

extension Events.EndOfTrackEvent : Dumpable {
	func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
		return dump()
	}

	func dump() -> String {
		return "-- END OF TRACK --"
	}
}
