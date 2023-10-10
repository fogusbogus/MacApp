//
//  Timeline.swift
//  
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

/*
 A timeline contains events of some sort against an index which is time-significant. Multiple events can be held against the same time index.
 */

open class Timeline {
	init() {
		self.events = [:]
	}
	init(events: [Int:[any TimelineEvent]]) {
		self.events = events
	}
	private var events: [Int:[any TimelineEvent]] = [:]
	
	@discardableResult
	func addEvent<T>(position: Int, event: T) -> T where T : TimelineEvent {
		if let _ = events[position] {
			if event.uniqueToDelta {
				events[position]?.removeAll(where: {String(describing: $0.self) == String(describing: event.self)})
			}
			events[position]?.append(event)
		}
		else {
			events[position] = [event]
		}
		return event
	}
	
	struct IndexedEvent {
		var position: Int
		var event: any TimelineEvent
	}
	
	func getOrderedEvents() -> [IndexedEvent] {
		var ret: [IndexedEvent] = []
		events.keys.sorted().forEach { position in
			ret.append(contentsOf: events[position]!.map {IndexedEvent(position: position, event: $0)})
		}
		return ret
	}
	
	func getLastPosition() -> Int {
		return events.keys.max() ?? 0
	}
	
	func getTimelineData(channel: Int = 0, noteOffset: Int = 0) -> [UInt8] {
		var bytes: [UInt8] = []
		
		var lastPosition = 0
		var lastNoteOn: NoteEvent? = nil
		var distance = 0
		events.keys.sorted().forEach { position in
			let positionEvents = events[position]!.filter {!($0 is NonDataEvent)}
			distance += position - lastPosition
			lastPosition = position
			positionEvents.forEach { event in
				
				if let note = event as? NoteEvent {
					bytes.append(contentsOf: distance.getDeltaBytes())
					distance = 0
					if lastNoteOn != nil {
						bytes.append(contentsOf: lastNoteOn!.toNoteOffMIDIData(channel: channel, offset: noteOffset))
						bytes.append(contentsOf: 0.getDeltaBytes())
					}
					bytes.append(contentsOf: note.toMIDIData(channel: channel, offset: noteOffset))
					lastNoteOn = note
				}
				else {
					if event is NoteOffEvent {
						if lastNoteOn != nil {
							bytes.append(contentsOf: distance.getDeltaBytes())
							distance = 0
							bytes.append(contentsOf: lastNoteOn!.toNoteOffMIDIData(channel: channel, offset: noteOffset))
							lastNoteOn = nil
						}
					}
					else {
						bytes.append(contentsOf: distance.getDeltaBytes())
						distance = 0
						bytes.append(contentsOf: event.toMIDIData(channel: channel))
					}
				}
			}
		}
//		if lastNoteOn != nil {
//			bytes.append(contentsOf: 0.getDeltaBytes())
//			bytes.append(contentsOf: lastNoteOn!.toNoteOffMIDIData(channel: channel, offset: noteOffset))
//		}
		return bytes
	}
	
	func getBarDelta(_ barNo: Int) -> Int {
		guard barNo >= 0 else { return 0 }
		var barNo = barNo
		var timeSigs = events.compactMapValues { $0.first(where: {$0 is TimeSignatureEvent}) }
		var currentTS = try! TimeSignatureEvent(numerator: 4, denominator: 4)
		var delta = 0
		while barNo > 0 {
			let barTS = timeSigs.filter {$0.key <= delta}.first?.value as? TimeSignatureEvent ?? currentTS
			currentTS = barTS
			timeSigs = timeSigs.filter {$0.key > delta}
			delta += barTS.ticksPerBar()
			barNo -= 1
		}
		
		return delta
	}
	
	struct BarInfo {
		
		init(barNo: Int, delta: Int, length: Int, denominatorLength: Int, timeSignature: TimeSignatureEvent) {
			self.barNo = barNo
			self.delta = delta
			self.length = length
			self.denominatorLength = denominatorLength
			self.timeSignature = timeSignature
		}
		
		var barNo: Int
		var delta: Int
		var length: Int
		var denominatorLength: Int
		var timeSignature: TimeSignatureEvent
	}
	
	func getBarInfo(_ barNo: Int) -> BarInfo {
		var ret = BarInfo(barNo: barNo, delta: getBarDelta(barNo), length: 0, denominatorLength: 0, timeSignature: try! TimeSignatureEvent(numerator: 4, denominator: 4))
		if let tsKey = events.filter({$0.value.contains(where: {$0 is TimeSignatureEvent})}).map({$0.key}).reversed().first {
			ret.timeSignature = events[tsKey]?.first(where: {$0 is TimeSignatureEvent}) as! TimeSignatureEvent
			ret.length = ret.timeSignature.ticksPerBar()
			ret.denominatorLength = ret.timeSignature.ticksPerDenominator()
		}
		else {
			ret.denominatorLength = 96
			ret.length = 96 * 4
		}
		return ret
	}
	
	func getBarNoFromDelta(_ delta: Int) -> Int {
		guard delta >= 0 else { return 0 }
		var barNo = 0
		
		var timeSigs = events.compactMapValues { $0.first(where: {$0 is TimeSignatureEvent}) }.filter {$0.key <= delta}
		var delta = delta
		var currentTS = try! TimeSignatureEvent(numerator: 4, denominator: 4)
		var pos = 0
		while delta > 0 {
			if timeSigs.contains(where: {$0.key <= pos}) {
				currentTS = timeSigs.filter {$0.key <= pos}.sorted(by: {$0.key > $1.key}).first!.value as! TimeSignatureEvent
				timeSigs = timeSigs.filter {$0.key > pos}
			}
			pos += currentTS.ticksPerBar()
			delta -= currentTS.ticksPerBar()
			if delta >= 0 {
				barNo += 1
			}
		}
		return barNo
	}
	
	func getLastInstanceOf<T>(_ delta: Int, defaultValue: T? = nil) -> T? {
		if let key = events.keys.filter({$0 <= delta && events[$0]!.contains(where: {$0 is T})}).sorted().reversed().first {
			if let ret = events[key]!.first(where: {$0 is T}) {
				return ret as? T
			}
		}
		return defaultValue
	}
}



public protocol TimelineEvent : Identifiable {
	var id: UUID {get}
	func toMIDIData(channel: Int) -> [UInt8]
	var uniqueToDelta: Bool { get }
}

extension TimelineEvent {
	func stringBytes(_ text: String, type: TextType) -> [UInt8] {
		var ret: [UInt8] = []
		ret.append(contentsOf: [255, UInt8(type.rawValue)])
		ret.append(contentsOf: text.lengthOfBytes(using: .utf8).getDeltaBytes())
		ret.append(contentsOf: Array(text.utf8))
		return ret
	}
}

public enum TextType : Int {
	case text = 1, copyright = 2, trackName = 3, instrumentName = 4, lyric = 5, marker = 6
}
