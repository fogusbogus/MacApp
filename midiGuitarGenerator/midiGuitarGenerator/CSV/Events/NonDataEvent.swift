//
//  NonDataEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

public class NonDataEvent : TimelineEvent {
	public var type: Events.Types {
		get {
			return .nonDataEvent
		}
	}
	
	public var id: UUID = UUID()
	
	public func toMIDIData(channel: Int) -> [UInt8] {
		return []
	}
	
	public var uniqueToDelta: Bool = true
}




