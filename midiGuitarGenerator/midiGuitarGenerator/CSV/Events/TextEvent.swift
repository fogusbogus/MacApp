//
//  TextEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

extension Events {
	
	open class TextEvent : TimelineEvent, Dumpable {
		public var type: Events.Types {
			get {
				return .text
			}
		}
		
		public var id: UUID = UUID()
		
		public init(_ text: String) {
			self.text = text
			self.textType = .text
		}
		
		var text: String
		var textType: TextType
		
		public func toMIDIData(channel: Int) -> [UInt8] {
			return stringBytes(text, type: textType)
		}
		
		public var uniqueToDelta: Bool = false
		
		func dump(delta: Int, timeline: Timeline? = nil, mainTimeline: Timeline? = nil) -> String {
			return dump()
		}

		func dump() -> String {
			return "TEXT \"\(text)\""
		}
	}
}

extension Events.TextEvent {
	static func parse(columns: CSV.MusicFileReader.FieldIndex, data: [String]) throws -> Events.TextEvent? {
		return Events.TextEvent(data[columns[.value]!])
	}
}

extension Events {
	open class LyricEvent: Events.TextEvent {
		public override var type: Events.Types {
			get {
				return .lyric
			}
		}
		
		override init(_ text: String) {
			super.init(text)
			self.textType = .lyric
		}
		
		override func dump() -> String {
			return "LYRIC \"\(text)\""
		}
	}
	
	open class CopyrightEvent: Events.TextEvent {
		public override var type: Events.Types {
			get {
				return .copyright
			}
		}
		
		override init(_ text: String) {
			super.init(text)
			self.textType = .copyright
		}
		
		override func dump() -> String {
			return "COPYRIGHT \"\(text)\""
		}
	}
	
	open class InstrumentNameEvent: Events.TextEvent {
		public override var type: Events.Types {
			get {
				return .instrumentName
			}
		}
		
		override init(_ text: String) {
			super.init(text)
			self.textType = .instrumentName
		}
		
		override func dump() -> String {
			return "INSTRUMENT \"\(text)\""
		}
	}
	
	open class MarkerEvent: Events.TextEvent {
		public override var type: Events.Types {
			get {
				return .marker
			}
		}
		
		override init(_ text: String) {
			super.init(text)
			self.textType = .marker
		}
		
		override func dump() -> String {
			return "MARKER \"\(text)\""
		}
	}
	
	open class TrackNameEvent: Events.TextEvent {
		public override var type: Events.Types {
			get {
				return .trackName
			}
		}
		
		override init(_ text: String) {
			super.init(text)
			self.textType = .trackName
		}
		
		override func dump() -> String {
			return "TRACKNAME \"\(text)\""
		}
	}
}


