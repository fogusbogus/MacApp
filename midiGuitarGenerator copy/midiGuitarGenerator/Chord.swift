//
//  Chord.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

public class Chord : Codable {
	
	func clone() -> Chord {
		let ret = Chord()
		ret.name = self.name
		ret.collection = self.collection
		ret.ref = self.ref?.clone()
		ret.version = self.version
		ret.desc = self.desc
		ret.frets = self.frets
		return ret
	}
	
	public init() {
		self.name = ""
		self.collection = ""
		self.ref = nil
		self.version = 1
		self.desc = ""
		self.frets = []
	}
	
	public init(_ post: (Chord) -> Void) {
		self.name = ""
		self.collection = ""
		self.ref = nil
		self.version = 1
		self.desc = ""
		self.frets = []
		post(self)
	}
	
	enum Errors : Error {
		case chordReferenceIsRecursive
	}
	
	var chordLookupDelegate: ChordLookupDelegate? {
		didSet {
			self.ref?.chordLookupDelegate = self.chordLookupDelegate
		}
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: .name)
		self.collection = try container.decode(String.self, forKey: .collection)
		self.ref = try container.decodeIfPresent(ChordRef.self, forKey: .ref)
		self.version = try container.decodeIfPresent(Int.self, forKey: .version)
		self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
		self.frets = try container.decode([Int].self, forKey: .frets)
	}
	
	init(collection: String, name: String, version: Int = 1, desc: String? = "", frets: [Int] = []) {
		self.collection = collection
		self.name = name
		self.version = version
		self.desc = desc
		self.frets = frets
	}
	
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.collection, forKey: .collection)
		try container.encodeIfPresent(self.ref, forKey: .ref)
		try container.encodeIfPresent(self.version, forKey: .version)
		try container.encodeIfPresent(self.desc, forKey: .desc)
		try container.encode(self.frets, forKey: .frets)
	}
	
	enum CodingKeys : String, CodingKey {
		case name, ref, version, desc, frets, collection
	}
	public var name: String
	public var collection: String
	public var ref: ChordRef?
	public var version: Int? = 1
	public var desc: String? = ""
	public var frets: [Int]
	
	func getFrets(_ recursive: [Chord] = []) throws -> [Int] {
		//Let's make sure we're not in a recursive loop
		if recursive.contains(where: { ci in
			return ci.name == self.name && ci.version == self.version
		}) {
			throw Errors.chordReferenceIsRecursive
		}
		var recursive = recursive
		recursive.append(self)
		if let ref = ref {
			if let chord = ref.chordLookupDelegate?.getChord(name: ref.name, version: ref.version ?? 1, collection: ref.collection) {
				return try chord.getFrets(recursive).map { $0 + ($0 < 0 ? 0 : (ref.offset ?? 0)) }
			}
		}
		return frets
	}
	
	func generateMask() -> String {
		return frets.map {$0 < 0 ? "X" : "-"}.joined()
	}
}

