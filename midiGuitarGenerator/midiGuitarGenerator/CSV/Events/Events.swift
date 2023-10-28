//
//  Events.swift
//  midiGuitarGenerator
//
//  Created by Matt Hogg on 14/10/2023.
//

import Foundation

public class Events {
	public enum Types {
		case decay, emulation, endOfTrack, noteOn, noteOff, strumMistrike, strumVariation, tempo, timeSignature, tuning, variation, velocity, interval, maxLength, text, lyric, copyright, marker, instrumentName, trackName, nonDataEvent
	}
}

