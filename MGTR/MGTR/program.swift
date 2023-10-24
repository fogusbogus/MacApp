//
//  main.swift
//  MGTR
//
//  Created by Matt Hogg on 21/10/2023.
//

import Foundation
import ArgumentParser

@main
struct MGTR: ParsableCommand {
	@Argument(help: "The chord CSV to use")
	var chordFile: String
	
	@Argument(help: "The music CSV to use")
	var musicFile: String
	
	@Argument(help: "The output MIDI file")
	var midiFile: String
	
	
	mutating func run() throws {
		
	}
}

