//
//  StrumHelper.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 15/10/2023.
//

import Foundation

extension Events {
	class StrumHelper {
		
		enum Errors: Error {
			case invalidChord, missingColumn, illegalVelocity, illegalMask, noValidVelocity, intervalMustBeZeroOrPositive
		}
		
		static func parseStrum(columns: CSV.MusicFileReader.FieldIndex, data: [String], allChords: [Chord]) throws {
			guard let chord = allChords.find(collection: columns.get(data, .collection, "")!, name: columns.get(data, .chord, "")!, version: columns.get(data, .version, 1)!) else { throw Errors.invalidChord }
			guard columns.keys.containsAll([.mask, .v1, .v2, .v3, .v4, .v5, .v6]) else { throw Errors.missingColumn }
			
			//Make sure the velocities are legal
			//1. At least one velocity value
			//2. No velocity is outside of the range 0...127
			let vels : [String] = [
				columns.get(data, .v1, ""),
				columns.get(data, .v2, ""),
				columns.get(data, .v3, ""),
				columns.get(data, .v4, ""),
				columns.get(data, .v5, ""),
				columns.get(data, .v6, "")
			]
			
			//At least one velocity value
			if !vels.contains(where: {$0.deriveFloat() != nil}) {
				throw Errors.noValidVelocity
			}
			
			//No velocity is outside the range
			if vels.contains(where: {!(0...127).contains(Int($0.deriveFloat(127) ?? 0))}) {
				throw Errors.illegalVelocity
			}
			
			//Make sure the mask is legal
			let mask = columns.get(data, .mask, "------")
			if mask.count < 6 {
				throw Errors.illegalMask
			}
			
			//We can have all closed strings if the mask requires it (kind of like a mute)
			let interval = columns.get(data, .interval, 2)
			if interval < 0 {
				throw Errors.intervalMustBeZeroOrPositive
			}
		}
		
		static func parseAutoStrum(columns: CSV.MusicFileReader.FieldIndex, data: [String], allChords: [Chord]) throws {
			guard let chord = allChords.find(collection: columns.get(data, .collection, "")!, name: columns.get(data, .chord, "")!, version: columns.get(data, .version, 1)!) else { throw Errors.invalidChord }
		}
		
		static func parsePickSequence() throws {
		}
		
	}
}


extension String {
	func deriveFloat(_ asAPercentageOf: Float? = nil) -> Float? {
		if self.contains("%") {
			if let pc = asAPercentageOf {
				if let value = Double(self.keepNumeric()) {
					return Float(Double(pc) * value)
				}
			}
			return nil
		}
		return Float(self)
	}
}
