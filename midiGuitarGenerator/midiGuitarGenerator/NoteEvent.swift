//
//  NoteEvent.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

class NoteEvent : TimelineEvent {
	
	var id: UUID = UUID()
	
	init(note: Int, velocity: Int) {
		self.note = note
		self.velocity = velocity
	}
	
	var note: Int {
		didSet {
			if !(0...127).contains(note) {
				note = note.clamped(to: 0...127)
			}
		}
	}
	var velocity: Int {
		didSet {
			if !(0...127).contains(velocity) {
				velocity = velocity.clamped(to: 0...127)
			}
		}
	}
	
	func toMIDIData(channel: Int = 0) -> [UInt8] {
		return [UInt8(144+channel), UInt8(note), UInt8(velocity)]
	}
	func toMIDIData(channel: Int = 0, offset: Int) -> [UInt8] {
		let noteValue = note
		note += offset
		let ret = toMIDIData(channel: channel)
		note = noteValue
		return ret
	}

	var uniqueToDelta: Bool = true
	
	func toNoteOffMIDIData(channel: Int = 0) -> [UInt8] {
		return [UInt8(128+channel), UInt8(note), 0x40]
	}
	func toNoteOffMIDIData(channel: Int = 0, offset: Int) -> [UInt8] {
		let noteValue = note
		note += offset
		let ret = toMIDIData(channel: channel)
		note = noteValue
		return ret
	}

	var isNoteOff: Bool {
		get {
			return velocity == 0
		}
	}
	
}
