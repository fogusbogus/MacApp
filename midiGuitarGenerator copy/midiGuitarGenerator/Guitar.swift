//
//  Guitar.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

public class Guitar {
	
	public init() {
		setupTrackNames()
	}
	
	private var lastPosition : Int = 0
	
	public init(timeline: Timeline, strings: [Int : Timeline]) {
		self.timeline = timeline
		self.strings = strings
		setupTrackNames()
	}
	
	private func setupTrackNames() {
		timeline.addEvent(position: 0, event: CopyrightEvent("Guitar MIDI Generator (c) 1997-2023 Matt Hogg"))
		timeline.addEvent(position: 0, event: TrackNameEvent("Event track - no musical data"))
		strings.keys.forEach { idx in
			var name = "String \(1 + idx % 6)" + (idx > 5 ? " (12-string extra)" : "")
			strings[idx]?.addEvent(position: 0, event: TrackNameEvent(name))
		}
	}
	
	var timeline: Timeline = Timeline()
	
	//12 possible strings
	var strings: [Int:Timeline] = [0:Timeline(), 1:Timeline(), 2:Timeline(), 3:Timeline(), 4:Timeline(), 5:Timeline(), 6:Timeline(), 7:Timeline(), 8:Timeline(), 9:Timeline(), 10:Timeline(), 11:Timeline()]
	
	public enum Direction {
		case up, down
	}
	
	private func addNote(stringNo: Int, offset: Int, position: Int, velocity: Int, alternateStringsArray: [Int:Timeline]? = nil) {
		guard (0...11).contains(stringNo) else { return }
		let tuning = timeline.getLastInstanceOf(position, defaultValue: Tuning())!
		let note = tuning.notes[stringNo] + offset
		if let alternateStringsArray = alternateStringsArray {
			alternateStringsArray[stringNo]?.addEvent(position: position, event: NoteEvent(note: note.clamped(to: 0...127), velocity: velocity.asMIDIVelocity()))
		}
		else {
			strings[stringNo]?.addEvent(position: position, event: NoteEvent(note: note.clamped(to: 0...127), velocity: velocity.asMIDIVelocity()))
		}
	}
	public func allNotesOff(timecode: String) {
		allNotesOff(position: TimeCode.translateToDelta(timecode, timeline: timeline))
	}
	public func allNotesOff(position: Int) {
		(0...11).forEach { stringNo in
			strings[stringNo]?.addEvent(position: position, event: NoteOffEvent())
		}
	}
	
	@discardableResult
	public func addEvent(position: Int, _ event: any TimelineEvent) -> any TimelineEvent {
		timeline.addEvent(position: position, event: event)
		return event
	}
	
	@discardableResult
	public func addEvent(timecode: String, _ event: any TimelineEvent) -> any TimelineEvent {
		timeline.addEvent(position: TimeCode.translateToDelta(timecode, timeline: timeline), event: event)
		return event
	}
	
	public func strum(chord: Chord, timecode: String, mask: String, velocities: [Int], interval: Int, direction: Direction = .down) {
		let tc = TimeCode.translateToDelta(timecode, timeline: timeline)
		strum(chord: chord, position: tc, mask: mask.getMask(), velocities: velocities, interval: interval, direction: direction)
	}
	
	public func autoStrum(chord: Chord, timecode: String, velocity: Int = 127, interval: Int = 4, direction: Direction = .down) {
		strum(chord: chord, timecode: timecode, mask: chord.generateMask(), velocity: velocity, interval: interval, direction: direction)
	}
	
	public func strum(chord: Chord, timecode: String, mask: String, velocity: Int, interval: Int, direction: Direction = .down) {
		let position = TimeCode.translateToDelta(timecode, timeline: timeline)
		let variation = timeline.getLastInstanceOf(position, defaultValue: VariationEvent(range: -4...4, isPercent: false))
		let decay = timeline.getLastInstanceOf(position, defaultValue: DecayEvent(value: 4.0, isPercent: true))
		var newVelocity = variation?.generate(value: Float(velocity), rangeLimit: 1...127)
		if velocity == 0 {
			newVelocity = 0
		}
		let maskBool = mask.getMask()
		var start = Int(maskBool.firstIndex(of: true)?.description ?? "") ?? -1
		var end = Int(maskBool.lastIndex(of: true)?.description ?? "") ?? -1
		let mistrikeEvent = timeline.getLastInstanceOf(position, defaultValue: StrumMistrike_Event(start: 0, end: 0))!
		let newStartEnd = mistrikeEvent.generate(start: start, end: end)
		start = newStartEnd.start
		end = newStartEnd.end
		var velocities : [Int] = [-1,-1,-1,-1,-1,-1]
		(start...end).forEach { stringNo in
			let iteration = direction == .down ? stringNo - start : end - stringNo
			let newVel = decay!.apply(newVelocity!, iteration: iteration)
			velocities[stringNo] = Int(newVel)
		}
		strum(chord: chord, position: position, mask: maskBool, velocities: velocities, interval: interval, direction: direction)
	}
	
	public func strum(chord: Chord, position: Int, mask: [Bool], velocities: [Int], interval: Int, direction: Direction = .down) {
		let string12 = timeline.getLastInstanceOf(position, defaultValue: Emulation(is12String: false))!
		var start = Int(mask.firstIndex(of: true)?.description ?? "") ?? -1
		var end = Int(mask.lastIndex(of: true)?.description ?? "") ?? -1
		let vStart = Int(velocities.firstIndex(where: {$0 > 0})?.description ?? "") ?? -1
		let vEnd = Int(velocities.lastIndex(where: {$0 > 0})?.description ?? "") ?? -1
		start = min(start, vStart)
		end = max(end, vEnd)
		if start < 0 || end < 0 {
			return
		}
		var position = position
		(start...end).forEach { stringNo in
			let stringNo = direction == .down ? stringNo : end - (stringNo - start)
			if string12.is12String {
				if !mask[stringNo] || velocities[stringNo] == 0 {
					addNote(stringNo: stringNo, offset: chord.frets[stringNo], position: position, velocity: 0)
					addNote(stringNo: stringNo+6, offset: chord.frets[stringNo], position: position, velocity: 0)
				}
				else {
					addNote(stringNo: stringNo, offset: chord.frets[stringNo], position: position, velocity: velocities[stringNo])
					addNote(stringNo: stringNo+6, offset: chord.frets[stringNo], position: position, velocity: velocities[stringNo])
				}
			}
			else {
				if !mask[stringNo] || velocities[stringNo] == 0 {
					addNote(stringNo: stringNo, offset: chord.frets[stringNo], position: position, velocity: 0)
				}
				else {
					addNote(stringNo: stringNo, offset: chord.frets[stringNo], position: position, velocity: velocities[stringNo])
				}
			}
			position += interval
		}
	}
	
	public func generateMIDIData() -> Data {
		var ends : [Int] = strings.values.compactMap {$0.getLastPosition()}
		ends.append(timeline.getLastPosition())
		let end = (ends.max() ?? 0) + 384
		let strings = strings
		(0...11).forEach { stringNo in
			strings[stringNo]?.addEvent(position: end - 1, event: NoteOffEvent())
			addNote(stringNo: stringNo, offset: 0, position: end - 1, velocity: 0, alternateStringsArray: strings)
		}
		strings.forEach {$0.value.addEvent(position: end, event: EndOfTrackEvent())}
		let timeline = timeline
		timeline.addEvent(position: end, event: EndOfTrackEvent())
		
		var ret = MThd.data(trackCount: 13)
		ret.append(contentsOf: MTrk.data(data: Data(timeline.getTimelineData())))
		strings.sorted(by: {$0.key < $1.key}).forEach { track in
			ret.append(contentsOf: MTrk.data(data: Data(track.value.getTimelineData(channel: 0))))
		}
		return ret
	}
}
