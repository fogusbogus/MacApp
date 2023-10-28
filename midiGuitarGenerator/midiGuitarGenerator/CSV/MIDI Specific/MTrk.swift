//
//  MThd.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 09/10/2023.
//

import Foundation

extension MIDI {
	class MTrk {
		static func data(data: Data) -> Data {
			var bytes: [UInt8] = []
			bytes.append(contentsOf: Array("MTrk".utf8))
			bytes.append(contentsOf: data.count.getBytes(4))
			bytes.append(contentsOf: data)
			return Data(bytes)
		}
	}
}
