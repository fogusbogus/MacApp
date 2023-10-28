//
//  Command.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension CSV.MusicFileReader {
	
	typealias FieldIndex = [Field:Int]
	
	enum Command: String, CaseIterable {
		case tempo = "TEMPO~TMP~TPO~BPM"
		case title = "TITLE~TTL~TIT"
		case artist = "ARTIST~ART~BAND~GROUP"
		case decay = "DECAY~DEC~DCY"
		case comment = "COMMENT~COM~CMT~;~*"
		case strumDown = "SD~STRUMDOWN~DOWN"
		case strumUp = "SU~STRUMUP~UP"
		case allNotesOff = "X~NC~-"
		case pickSequence = "PS~SEQ~PICK"
		case timeSignature = "TIMESIG~TS~SIGNATURE~SIG"
		case variation = "VARI~VARIATION~VAR"
		case nextBar = "BAR"
		case autoStrumUp = "ASU"
		case autoStrumDown = "ASD"
		case maxLength = "MAXLENGTH~MAX~LENGTH~LEN~ML"
		
		enum Errors: Error {
			case noMatchFound
		}
		
		var canPersist: Bool {
			get {
				let valid : [Command] = [.strumUp, .strumDown, .autoStrumDown, .autoStrumUp]
				return valid.contains(self)
			}
		}
		
		static func match(_ text: String) throws -> Command {
			let ret : Command? = Command.allCases.first (where: { cmd in
				let splits = cmd.rawValue.split(separator: "~").map {String($0)}
				return splits.first(where: {$0.lowercased() == text.lowercased()}) != nil
			})
			if let value = ret {
				return value
			}
			throw Errors.noMatchFound
		}
		
		static func tryMatch(_ text: String) -> Command? {
			do {
				return try match(text)
			}
			catch {
				return nil
			}
		}
		
		func parse(columns: FieldIndex, data: [String], store: StoreCommands) throws -> (any TimelineEvent)? {
			switch self {
				case .tempo:
					if let tempo = try Events.TempoEvent.parse(columns: columns, data: data) {
						return tempo
					}
	
				case .title:
					return try Events.TextEvent.parse(columns: columns, data: data)
					
				case .artist:
					return try Events.TextEvent.parse(columns: columns, data: data)

				case .decay:
					return try Events.DecayEvent.parse(columns: columns, data: data)
					
				case .comment:
					return try Events.TextEvent.parse(columns: columns, data: data)

				case .strumDown:
					try Events.StrumHelper.parseStrum(columns: columns, data: data, allChords: [])

				case .strumUp:
					break
				case .allNotesOff:
					break
				case .pickSequence:
					break
				case .timeSignature:
					break
				case .variation:
					break
				case .nextBar:
					break
				case .autoStrumUp:
					break
				case .autoStrumDown:
					break
				case .maxLength:
					break
			}
			return nil
		}
	}
	

	enum Field: String, CaseIterable {
		case time = "Time~TS"
		case command = "Command~Cmd"
		case value = "Value~Val~Data"
		case collection = "Collection~Col~Coll"
		case chord = "Chord~Chd~Name"
		case mask = "Mask"
		case version = "Version~Ver~V"
		case v1 = "v1~1"
		case v2 = "v2~2"
		case v3 = "v3~3"
		case v4 = "v4~4"
		case v5 = "v5~5"
		case v6 = "v6~6"
		case interval = "Interval~Int"
		case notes = "Notes~Note~Comment"
		
		enum Errors: Error {
			case noMatchFound
		}
		
		static func match(_ text: String) throws -> Field {
			let ret : Field? = Field.allCases.first (where: { field in
				let splits = field.rawValue.split(separator: "~").map {String($0)}
				return splits.first(where: {$0.lowercased() == text.lowercased()}) != nil
			})
			if let value = ret {
				return value
			}
			throw Errors.noMatchFound
		}
		
		static func tryMatch(_ text: String) -> Field? {
			do {
				return try match(text)
			}
			catch {
			}
			return nil
		}
	}
}

extension Dictionary where Key == CSV.MusicFileReader.Field, Value == Int {
	func get<T>(_ data: [String], _ field: CSV.MusicFileReader.Field, _ defaultValue: T?) -> T? {
		if self.keys.contains(field) {
			if let index = self[field] {
				return data[index] as? T ?? defaultValue
			}
		}
		return defaultValue
	}
	
	func get<T>(_ data: [String], _ field: CSV.MusicFileReader.Field, _ defaultValue: T) -> T {
		if self.keys.contains(field) {
			if let index = self[field] {
				if defaultValue is Int {
					return Int(data[index]) as? T ?? defaultValue
				}
				if defaultValue is Float {
					return Float(data[index]) as? T ?? defaultValue
				}
				if defaultValue is Double {
					return Double(data[index]) as? T ?? defaultValue
				}
				return data[index] as? T ?? defaultValue
			}
		}
		return defaultValue
	}
}
