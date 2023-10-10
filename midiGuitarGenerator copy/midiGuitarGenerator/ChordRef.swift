//
//  ChordRef.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

open class ChordRef : Codable {
	
	init() {
		self.name = ""
		self.version = 1
		self.offset = 0
		self.chordLookupDelegate = nil
	}
	
	func clone() -> ChordRef {
		let ret = ChordRef()
		ret.name = self.name
		ret.version = self.version
		ret.chordLookupDelegate = self.chordLookupDelegate
		ret.offset = self.offset
		return ret
	}
	
	enum CodingKeys : String, CodingKey {
		case name, version, offset
	}
	var name: String
	var version: Int? = 1
	var collection: String = ""
	var offset: Int? = 0
	
	var chordLookupDelegate: ChordLookupDelegate?
}

