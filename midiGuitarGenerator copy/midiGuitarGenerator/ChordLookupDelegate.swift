//
//  ChordLookupDelegate.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

public protocol ChordLookupDelegate {
	func getChord(name: String, version: Int, collection: String) -> Chord?
}

extension Array where Element == Chord {
	public func find(collection: String, name: String, version: Int = 1) -> Chord? {
		return self.first { chord in
			return chord.collection.localizedCaseInsensitiveCompare(collection) == .orderedSame &&
			chord.name.localizedCaseInsensitiveCompare(name) == .orderedSame &&
			chord.version == version
		}
	}
}
