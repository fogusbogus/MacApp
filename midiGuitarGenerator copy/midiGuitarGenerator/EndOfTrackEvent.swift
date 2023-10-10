//
//  EndOfTrackEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

class EndOfTrackEvent : TimelineEvent {
	var id: UUID = UUID()
	
	func toMIDIData(channel: Int) -> [UInt8] {
		return [255, 0x2f, 0]
	}
	
	var uniqueToDelta: Bool = true
	
	
}
