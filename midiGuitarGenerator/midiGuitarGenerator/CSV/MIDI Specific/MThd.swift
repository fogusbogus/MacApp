//
//  MThd.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

extension MIDI {
	class MThd {
		static func data(trackCount: Int, ticksPerCrotchet: Int = 96, type: Int = 1) -> Data {
			var bytes : [UInt8] = []
			bytes.append(contentsOf: Array("MThd".utf8))
			bytes.append(contentsOf: 6.getBytes(4))
			bytes.append(contentsOf: type.getBytes(2))
			bytes.append(contentsOf: trackCount.getBytes(2))
			bytes.append(contentsOf: ticksPerCrotchet.getBytes(2))
			return Data(bytes)
		}
	}
}
