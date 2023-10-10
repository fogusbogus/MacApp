//
//  TextEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

open class TextEvent : TimelineEvent {
	public var id: UUID = UUID()
	
	public init(_ text: String) {
		self.text = text
		self.type = .text
	}
	
	var text: String
	var type: TextType
	
	public func toMIDIData(channel: Int) -> [UInt8] {
		return stringBytes(text, type: type)
	}
	
	public var uniqueToDelta: Bool = false
}

open class LyricEvent: TextEvent {
	override init(_ text: String) {
		super.init(text)
		self.type = .lyric
	}
}

open class CopyrightEvent: TextEvent {
	override init(_ text: String) {
		super.init(text)
		self.type = .copyright
	}
}

open class InstrumentNameEvent: TextEvent {
	override init(_ text: String) {
		super.init(text)
		self.type = .instrumentName
	}
}

open class MarkerEvent: TextEvent {
	override init(_ text: String) {
		super.init(text)
		self.type = .marker
	}
}

open class TrackNameEvent: TextEvent {
	override init(_ text: String) {
		super.init(text)
		self.type = .trackName
	}
}
