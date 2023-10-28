//
//  MusicCSV.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 11/10/2023.
//

import Foundation

//class MusicCSV {
//	
//	typealias ValueList = [Command:String]
//	
//	static var testData = "Time,Cmd,value,Collection,Chord,Notes\n,,,,,\n,,,,,\n1.0.0,TEMPO,97,,,\n,TITLE,Living Forever,,,\n,ARTIST,Genesis,,,\n,DECAY,5%,,,\n,COMMENT,Guitar part (basic) by Mike Rutherford,,,\n,VARIATION,+-5%,,,\n,STRUMVELOCITY,100%,,,Set to OFF to turn off. This makes v1-v6 ineffectual.\n,INTERVAL,2,,,\n,,,,,\n3.1.0,ASD,,Intro,Ab,\n>2.48,,,,Eb,\n>2.72,X,,,,\n,ASU,,,Bb,\n,BAR\n>1.0,ASD,,,,\n>2.48,,,,,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Ab,\n>2.48,,,,Eb,\n,BAR\n8.1.0,,,,Ab,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Ab,\n>2.48,,,,Eb,\n>2.72,X,,,,\n,ASU,,,Bb,\n,BAR\n10.1.0,ASD,,,,\n>2.48,,,,,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Gb,\n>2.48,X,,,,\n,ASD,,,Eb,\n>4.0,X,,,,"
//	
//	
//	static func getGuitarTimelineFromData(data: String) -> (stringTimelines: [Timeline], metaTimeline: MetaEventTimeline) {
//		//Parse time signatures
//		var csv = CSVTranslation.getArrayFromCSVContent(csv: data)
//		if csv.count == 0 {
//			return (stringTimelines: [], metaTimeline: MetaEventTimeline())
//		}
//		let cols = csv.removeFirst()
//		var part : [Field:Int] = [:]
//		cols.forEach { col in
//			do {
//				let field = try Field.match(col)
//				part[field] = cols.firstIndex(of: col)
//			}
//			catch {
//				
//			}
//		}
//		
//		//This records the latest values set by the command. Useful for persisting settings in sequence.
//		var latestValues: ValueList = [
//			.allNotesOff: "",
//			.artist: "",
//			.comment: "",
//			.decay: "0",
//			.pickSequence: "",
//			.strumDown: "",
//			.strumUp: "",
//			.tempo: "120",
//			.timeSignature: "4/4",
//			.title: "",
//			.variation: ""
//		]
//		
//		if !part.keys.containsAll([.command, .time, .value]) {
//			return (stringTimelines: [], metaTimeline: MetaEventTimeline())
//		}
//		
//		//PARSE 1
//		var timeline = MetaEventTimeline()
//		var strings: [Timeline] = Array(repeating: Timeline(), count: 6)
//		var timestamp = "1:0:0"
//		csv.forEach { row in
//			do {
//				let position = try getTS(row[part[.time]!], currentTS: timestamp, meta: timeline)
//				timestamp = TimeCode.timecodeFromTicks(position, timeline)
//				let field = try Command.match(row[part[.command]!])
//				if field == .timeSignature {
//					timeline.addEvent(event: TimeSignatureEvent(row[part[.value]!]), position: position)
//				}
//			}
//			catch {}
//		}
//		
//		//PARSE 2
//		timestamp = "1:0:0"
//		var decay = Decay(value: 0.0)
//		csv.forEach { row in
//			do {
//				let position = try getTS(row[part[.time]!], currentTS: timestamp, meta: timeline)
//				timestamp = TimeCode.timecodeFromTicks(position, timeline)
//				let field = try Command.match(row[part[.command]!])
//				switch field {
//					case .tempo:
//						latestValues[.tempo] = timeline.addEvent(event: TempoEvent(tempo: Float(row[part[.value]!]) ?? 120), position: position).tempo.description
//					case .title:
//						latestValues[.title] = timeline.addEvent(event: TextEvent(text: row[part[.value]!] ), position: position).text
//					case .artist:
//						latestValues[.artist] = timeline.addEvent(event: TextEvent(text: row[part[.value]!] ), position: position).text
//					case .decay:
//						decay = Decay.parse(row[part[.value]!])
//						latestValues[.decay] = decay.value.description
//					case .comment:
//						latestValues[.comment] = timeline.addEvent(event: TextEvent(text: row[part[.value]!] ), position: position).text
//					case .strumDown:
//						break
//					case .strumUp:
//						break
//					case .allNotesOff:
//						break
//					case .pickSequence:
//						break
//					default:
//						break
//				}
//			}
//			catch {}
//		}
//		return (stringTimelines: strings, metaTimeline: timeline)
//	}
//	
//	class StrumData {
//		var metaTimeline: MetaEventTimeline
//		var stringTimelines: [Timeline]
//		var up: Bool
//		var row: [String]
//		var key: [Field:Int]
//		var decay: Decay
//		var position: Int
//		var chord: ChordInfo
//		
//		init(metaTimeline: MetaEventTimeline, stringTimelines: [Timeline], up: Bool = false, row: [String] = [], key: [Field : Int] = [:], decay: Decay = Decay(value: 0.0), position: Int = 0, chord: ChordInfo) {
//			self.metaTimeline = metaTimeline
//			self.stringTimelines = stringTimelines
//			self.up = up
//			self.row = row
//			self.key = key
//			self.decay = decay
//			self.position = position
//			self.chord = chord
//		}
//	}
//	
//	static func strum(data: StrumData, latest: ValueList) {
//		let mask = Array(data.row[data.key[.mask]!]).map {!"Xx".contains($0)}
//		var start = mask.firstIndex(of: true)
//		var end = mask.lastIndex(of: true)
//		if start == nil && end == nil {
//			return
//		}
//		start = start ?? 0
//		end = end ?? 5
//		if data.up {
//			swap(&start, &end)
//		}
//		var interval = Int(data.row[data.key[.interval]!]) ?? 0
//		var velocities = [data.row[data.key[.v1]!], data.row[data.key[.v2]!], data.row[data.key[.v3]!], data.row[data.key[.v4]!], data.row[data.key[.v5]!], data.row[data.key[.v6]!]]
//		var startVelText = velocities[start!]
//		var startVel = Int(startVelText)
//		var currentVel = 127
//		if startVel == nil {
//			currentVel = getVelocity(startVelText, previousValue: currentVel, decay: data.decay, iteration: 0, variation: VariationRange(text: latest[.variation]))
//		}
//		else {
//			currentVel = startVel!
//		}
//		var iteration = 0
//		(start!...end!).forEach { gString in
//			//data.timeline.addEvent(event: TimelineNote(note: <#T##Int#>, position: <#T##Int#>, velocity: <#T##Int#>, length: <#T##Int#>), position: <#T##Int#>)
//		}
//	}
//	
//	enum StrumDirection {
//		case none, up, down
//	}
//	
//	/// With a list of velocities (that could contain percentages and follow-ons - asterisks), we need to calculate the next velocity value for a given string and direction
//	/// - Parameters:
//	///   - velocities: <#velocities description#>
//	///   - stringNo: <#stringNo description#>
//	///   - variation: <#variation description#>
//	///   - ascending: <#ascending description#>
//	/// - Returns: <#description#>
//	static func getNextVelocity(velocities: [String], stringNo: Int, latestValues: ValueList, direction: StrumDirection = .none) -> (value: Int, velocities: [String]) {
//		// if the direction is none then we cannot change any of the velocities we return, we just need to give the value for the index. In this instance we are assuming a pick sequence
//		if direction == .none {
//			let vel = velocities[stringNo]
//			return (value: getVelocity(vel, previousValue: 127, decay: Decay(value: 0.0), iteration: 0, variation: latestValues[.variation]!.getVariationRange()), velocities: velocities)
//		}
//	}
//	
//	enum Field: String, CaseIterable {
//		case time = "Time~TS"
//		case command = "Command~Cmd"
//		case value = "Value~Val~Data"
//		case collection = "Collection~Col~Coll"
//		case chord = "Chord~Chd~Name"
//		case mask = "Mask"
//		case version = "Version~Ver~V"
//		case v1 = "v1~1"
//		case v2 = "v2~2"
//		case v3 = "v3~3"
//		case v4 = "v4~4"
//		case v5 = "v5~5"
//		case v6 = "v6~6"
//		case interval = "Interval~Int"
//		case notes = "Notes~Note~Comment"
//		
//		enum Errors: Error {
//			case noMatchFound
//		}
//		
//		static func match(_ text: String) throws -> Field {
//			let ret : Field? = Field.allCases.first (where: { field in
//				let splits = field.rawValue.split(separator: "~").map {String($0)}
//				return splits.first(where: {$0.lowercased() == text.lowercased()}) != nil
//			})
//			if let value = ret {
//				return value
//			}
//			throw Errors.noMatchFound
//		}
//	}
//	
//	enum ExecuteCommand {
//		case tempo(value: Float)
//		case title(text: String)
//		case artist(text: String)
//		case decay(value: Float)
//		case comment(text: String)
//		case strum(chord: Chord, mask: String, velocities: [Int], direction: Direction)
//		case autoStrum(chord: Chord, velocity: Int, direction: Direction)
//		case allNotesOff
//		case nextBar
//		case repeatBar(howFarBack: Int, repeating: Int)
//		case pick(chord: Chord, interval: Int)
//		case timeSignature(numerator: Int, denominator: Int)
//		case variation(range: ClosedRange<Float>)
//		case interval(value: Int)
//		case none
//		
//		enum Errors: Error {
//			case missingColumns, chordNotFound
//		}
//		
//		func decode(lookup: LookupCommand, infoProvider: InfoProvider) throws -> ExecuteCommand {
//			guard lookup.columns.keys.containsAll([.command, .time, .value]) else { throw Errors.missingColumns }
//			
//			switch try Command.match(lookup.get(.command)) {
//				case .tempo:
//					if let value = Float(data[columns[.value]!]) {
//						return .tempo(value: value)
//					}
//				case .title:
//					return .title(text: data[columns[.value]!])
//				case .artist:
//					return .artist(text: data[columns[.value]!])
//				case .decay:
//					if let value = Float(data[columns[.value]!]) {
//						return .decay(value: value)
//					}
//				case .comment:
//					return .comment(text: data[columns[.value]!])
//				case .strumDown:
//					if !columns.keys.containsAll([.chord, .collection, .interval, .mask, .v1, .v2, .v3, .v4, .v5, .v6, .version]) {
//						throw Errors.missingColumns
//					}
//					if let chord = infoProvider.lookupChord(collection: data[columns[.collection]!], name: data[columns[.chord]!], version: Int(data[columns[.version]] ?? 1)) {
//						var interval = Int(data[columns[.version]!])
//					}
//					else {
//						throw Errors.chordNotFound
//					}
//					
//				case .strumUp:
//					break
//				case .allNotesOff:
//					break
//
//				case .pickSequence:
//					break
//
//				case .timeSignature:
//					break
//
//				case .variation:
//					break
//				case .nextBar:
//					return .nextBar
//				case .autoStrumUp:
//					break
//
//				case .autoStrumDown:
//					break
//
//			}
//		}
//	}
//	
//	enum Command: String, CaseIterable {
//		case tempo = "TEMPO~TMP~TPO~BPM"
//		case title = "TITLE~TTL~TIT"
//		case artist = "ARTIST~ART~BAND~GROUP"
//		case decay = "DECAY~DEC~DCY"
//		case comment = "COMMENT~COM~CMT~;~*"
//		case strumDown = "SD~STRUMDOWN~DOWN"
//		case strumUp = "SU~STRUMUP~UP"
//		case allNotesOff = "X~NC~-"
//		case pickSequence = "PS~SEQ~PICK"
//		case timeSignature = "TIMESIG~TS~SIGNATURE~SIG"
//		case variation = "VARI~VARIATION~VAR"
//		case nextBar = "BAR"
//		case autoStrumUp = "ASU"
//		case autoStrumDown = "ASD"
//		
//		enum Errors: Error {
//			case noMatchFound
//		}
//		
//		
//		static func match(_ text: String) throws -> Command {
//			let ret : Command? = Command.allCases.first (where: { cmd in
//				let splits = cmd.rawValue.split(separator: "~").map {String($0)}
//				return splits.first(where: {$0.lowercased() == text.lowercased()}) != nil
//			})
//			if let value = ret {
//				return value
//			}
//			throw Errors.noMatchFound
//		}
//		
//		func getMetaEvent() -> MetaEvent? {
//			switch self {
//					
//				case .tempo:
//					return TempoEvent(tempo: 0)
//				case .title:
//					return TextEvent(text: "")
//				case .artist:
//					return CopyrightEvent(text: "")
//				case .comment:
//					return MarkerEvent(text: "")
//				default:
//					return nil
//			}
//		}
//	}
//	
//	enum Errors: Error {
//		case illegalTimecode(timecode: String)
//		case timecodeOutOfSequence(timecode: String, previousTimecode: String)
//	}
//	
//	private var meta: MetaEventTimeline = MetaEventTimeline()
//	
//	static func getTS(_ ts: String, currentTS: String, meta: MetaEventTimeline) throws -> Int {
//		//Decide if we just use the ts we are passed or whether we need to calculate it
//		guard ts.trimmingCharacters(in: .whitespaces).count > 0 else { return TimeCode.ticks(currentTS, meta) }
//		
//		if ts.hasPrefix(">") {
//			//Calculated
//			let timestamp = ts
//			var ts = ts.replacingOccurrences(of: ":", with: ".").split(separator: ".").map {String($0)}
//			let cts = currentTS.replacingOccurrences(of: ":", with: ".").split(separator: ".").map {String($0)}
//			if ts.count > cts.count {
//				throw Errors.illegalTimecode(timecode: timestamp)
//			}
//			(0..<cts.count).forEach { i in
//				ts[ts.count - 1 - i] = cts[cts.count - 1 - i]
//			}
//			let retTS = TimeCode.ticks(ts.joined(separator: ":"), meta)
//			let retCTS = TimeCode.ticks(currentTS, meta)
//			if retTS < retCTS {
//				throw Errors.timecodeOutOfSequence(timecode: timestamp, previousTimecode: currentTS)
//			}
//			return retTS
//		}
//		else {
//			if ts.hasPrefix("+") {
//				//Calculated as an addition
//				let timestamp = ts
//				let ts = ts.getTimeCodeParts()
//				let cts = currentTS.getTimeCodeParts()
//				if ts.count > cts.count {
//					throw Errors.illegalTimecode(timecode: timestamp)
//				}
//				//Add delta can be figured out
//				let startOfBarDelta = TimeCode.ticks("\(currentTS.getTimeCodePart(part: .bar)):0:0", meta)
//				let newTimeline = MetaEventTimeline()
//				newTimeline.addEvent(event: meta.getLastTimeSignatureEvent(position: startOfBarDelta), position: 0)
//				let addDelta = TimeCode.ticks(timestamp.after("+").getTimeCodeParts().map {String($0)}.joined(separator: ":"), newTimeline)
//				return startOfBarDelta + addDelta
//			}
//		}
//		return TimeCode.ticks(ts, meta)
//	}
//	
//	static func getVelocity(_ vel: String, previousValue: Int = 127, decay: Decay = Decay(value: 2.0, isPercent: true), iteration: Int = 0, variation: VariationRange? = nil) -> Int {
//		let variation = variation ?? VariationRange(text: "0")
//		var vel = vel
//		if vel.contains("*") {
//			vel = "\(previousValue)"
//		}
//		let topVel = Int(variation.generate(value: Constants.MIDIVelocityRange.upperBound, rangeLimit: Constants.MIDIVelocityRange)).asMIDIInt()
//		if vel.contains("%") {
//			let pc = Double(topVel) * ((Double(vel.keepNumeric()) ?? 100.0) / 100.0)
//			return Int(decay.getDecayedValue(pc, iteration: iteration)).asMIDIInt()
//		}
//		let newVel = decay.getDecayedValue(Double(vel.keepNumeric()) ?? Double(topVel), iteration: iteration)
//		return Int(newVel).asMIDIInt()
//	}
//	
//	static func getVelocity(_ vel: String, previousValue: Int = 127, decay: Decay = Decay(value: 2.0, isPercent: true), iteration: Int = 0, variation: VariationRange = VariationRange(range: 0...0, isPercent: false)) -> Int {
//		var vel = vel
//		if vel.contains("*") {
//			vel = "\(previousValue)"
//		}
//		let topVel = Double(Int(127.0 + Float.random(in: variation.range)).asMIDIInt())
//		if vel.contains("%") {
//			let pc = topVel * ((Double(vel.keepNumeric()) ?? 100.0) / 100.0)
//			return Int(decay.getDecayedValue(pc, iteration: iteration)).asMIDIInt()
//		}
//		let newVel = decay.getDecayedValue(Double(vel.keepNumeric()) ?? topVel, iteration: iteration)
//		return Int(newVel).asMIDIInt()
//	}
//	
//}

struct Constants {
	static let MIDIVelocityRange : ClosedRange<Float> = 0...127
}
