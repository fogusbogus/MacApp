//
//  MIDIFileTools.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 10/10/2023.
//

import Foundation

extension MIDI {
	
	open class Type0Timeline {
		var events: [Int:[UInt8]] = [:]
		
		var position: Int = 0
		
		public func resetPointer() {
			position = 0
		}
		
		func addMIDIData(data: [UInt8]) {
			guard data.count > 0 else { return }
			//The first part of the MIDI data is a delta number (inner-deltas must be zero)
			var data = data
			var deltaBytes : [UInt8] = []
			while data.first! >= 0x80 {
				deltaBytes.append(data.removeFirst())
			}
			deltaBytes.append(data.removeFirst())
			position += deltaBytes.translateDeltaToInt()
			if events.keys.contains(position) {
				data.insert(0, at: 0)
				events[position]?.append(contentsOf: data)
			}
			else {
				events[position] = data
			}
		}
		
		func dumpMIDI() -> [UInt8] {
			var lastPosition = 0
			var ret: [UInt8] = []
			events.keys.sorted().forEach { position in
				let delta = position - lastPosition
				lastPosition = position
				ret.append(contentsOf: delta.getDeltaBytes())
				ret.append(contentsOf: events[position]!)
			}
			return ret
		}
	}
}

extension Array where Element == UInt8 {
	func translateDeltaToInt() -> Int {
		var ret = 0
		self.forEach { byte in
			ret <<= 7
			ret |= Int(byte & 0x7f)
		}
		return ret
	}
}
