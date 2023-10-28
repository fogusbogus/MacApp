//
//  MusicFileReader.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

extension CSV {
	
	public class MusicFileReader {
		
		public static func getTestGuitar() throws -> Guitar {
			let chords = ChordCSV.readChordsFromCSV(csv: ChordCSV.testData)
			return try MusicFileReader.parse(testData, chords: chords)
		}
		
			static var testData = "Time,Cmd,value,Collection,Chord,Notes\n,,,,,\n,,,,,\n1.1.1,TEMPO,97,,,\n,TITLE,Living Forever,,,\n,ARTIST,Genesis,,,\n,DECAY,5%,,,\n,COMMENT,Guitar part (basic) by Mike Rutherford,,,\n,VARIATION,+-5%,,,\n,STRUMVELOCITY,100%,,,Set to OFF to turn off. This makes v1-v6 ineffectual.\n,INTERVAL,2,,,\n,,,,,\n1.1.0,ASD,,Intro,Ab,\n>2.48,,,,Eb,\n,,,,,\n>4.72,ASU,,,Bb,\n,BAR\n>1.0,ASD,,,,\n>2.48,,,,,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Ab,\n>2.48,,,,Eb,\n,BAR\n>1.0,,,,Ab,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Ab,\n>2.48,,,,Eb,\n,,,,,\n>4:72,ASU,,,Bb,\n,BAR\n>1.0,ASD,,,,\n>2.48,,,,,\n>2.72,X,,,,\n,BAR\n>1.0,ASD,,,Gb,\n>2.48,ASD,,,Eb,\n>4.0,X,,,,\n"
		
		enum Errors: Error {
			case illegalTimecode(timecode: String)
			case timecodeOutOfSequence(timecode: String, previousTimecode: String)
			case defaultColumnsNotProvided
		}
		
		static func persistValues(_ data: [String], columns: FieldIndex, persistentColumns: inout [Field:String]) -> [String] {
			var ret = data
			//Can we store the data for this?
			var canPersist = Command.tryMatch(columns.get(data, .command, "")!)?.canPersist ?? false
			columns.forEach { kv in
				let col = kv.key
				let idx = kv.value
				if persistentColumns.keys.contains(col) {
					if ret[idx].trimmingCharacters(in: .whitespaces).isEmpty {
						ret[idx] = persistentColumns[col]!
					}
					else {
						if canPersist {
							persistentColumns[col] = ret[idx]
						}
					}
				}
			}
			return ret
		}
		
		public static func parse(_ fileContent: String, chords: [Chord]) throws -> Guitar {
			let guitar = Guitar()
			var csv = CSVTranslation.getArrayFromCSVContent(csv: fileContent, options: CSVTranslation.Options(alignColumnCount: true)).filter { array in
				return array.contains(where: {!$0.isEmpty})
			}
			var persistentColumns: [Field:String] = [.chord:"", .collection:"", .time:"", .value:"", .mask:"", .version:"", .command:""]
			let headers = csv.removeFirst()
			var columns : FieldIndex = [:]
			(0..<headers.count).forEach{ index in
				let col = headers[index]
				do {
					columns[try Field.match(col)] = index
				}
				catch {
				}
			}
			if !columns.keys.containsAll([.command, .value]) {
				throw Errors.defaultColumnsNotProvided
			}
			var delta = 0
			var lastChord : Chord? = nil
			//Read the content
			try csv.forEach { _line in
				if _line.joined(separator: "").trimmingCharacters(in: .whitespaces).starts(with: ";") {
					return
				}
				let line = persistValues(_line, columns: columns, persistentColumns: &persistentColumns)
				let ts = columns.get(_line, .time, "")
				if !ts.isEmpty {
					let newTC = TimeCode.ratifyTimeCode(ts, inRelationToDelta: delta, timeline: guitar.timeline)
					delta = TimeCode.translateToDelta(newTC, timeline: guitar.timeline)
				}
				if let cmd = Command.tryMatch(columns.get(line, .command, "")) {
					switch cmd {
						case .tempo:
							do {
								guitar.addEvent(position: delta, try Events.TempoEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .title:
							do {
								guitar.addEvent(position: delta, try Events.TextEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .artist:
							do {
								guitar.addEvent(position: delta, try Events.TextEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .decay:
							do {
								guitar.addEvent(position: delta, try Events.DecayEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .comment:
							do {
								guitar.addEvent(position: delta, try Events.TextEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .strumDown:
							break
						case .strumUp:
							break
						case .allNotesOff:
							guitar.allNotesOff(position: delta)
						case .pickSequence:
							if let chord = chords.find(columns: columns, data: line) {
								let mute = chord != lastChord
								lastChord = chord
								delta = try guitar.pickSequence(position: delta, chord: chords.find(columns: columns, data: line)!, columns: columns, data: line)
							}
						case .timeSignature:
							do {
								guitar.addEvent(position: delta, try Events.TimeSignatureEvent(timeSignature: columns.get(line, .value, "")))
							}
							catch {}
						case .variation:
							do {
								guitar.addEvent(position: delta, try Events.VariationEvent.parse(columns: columns, data: line)!)
							}
							catch {}
						case .nextBar:
							delta = TimeCode.toNextBarDelta(delta, timeline: guitar.timeline)
						case .autoStrumUp:
							if let chord = chords.find(columns: columns, data: line) {
								let mute = chord != lastChord
								lastChord = chord
								guitar.autoStrum(chord: chords.find(columns: columns, data: line)!, timecode: TimeCode.translateToTimeCode(delta, timeline: guitar.timeline), direction: .up, forceMute: mute)
							}
						case .autoStrumDown:
							if let chord = chords.find(columns: columns, data: line) {
								let mute = chord != lastChord
								lastChord = chord
								guitar.autoStrum(chord: chords.find(columns: columns, data: line)!, timecode: TimeCode.translateToTimeCode(delta, timeline: guitar.timeline), direction: .down, forceMute: mute)
							}
							
						case .maxLength:
							do {
								guitar.addEvent(position: delta, try Events.MaxLengthEvent.parse(columns: columns, data: line)!)
							}
							catch {}
					}
				}
			}
			return guitar
		}
	}
	
}
