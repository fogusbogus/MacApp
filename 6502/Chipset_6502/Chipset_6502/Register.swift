//
//  Register.swift
//  Chipset_6502
//
//  Created by Matt Hogg on 24/01/2021.
//

import Foundation

typealias BYTE = UInt8
typealias WORD = UInt16

class CPU {
	
	init() {
		reset()
	}
	
	var PC : WORD = 0
	var SP : WORD = 0
	
	var A : BYTE = 0, X : BYTE = 0, Y : BYTE = 0
	
	var FLAGS : BYTE = 0
	
	private func setFlagBit(_ bit: UInt8, _ isSet: Bool) {
		var toSet = FLAGS | bit
		if !isSet {
			toSet -= bit
		}
		FLAGS = toSet
	}
	
	var CARRY : Bool {
		get {
			return (FLAGS & 1) == 1
		}
		set {
			setFlagBit(1, newValue)
		}
	}
	var ZERO : Bool {
		get {
			return (FLAGS & 2) == 2
		}
		set {
			setFlagBit(2, newValue)
		}
	}
	var IRQ_DISABLE : Bool {
		get {
			return (FLAGS & 4) == 4
		}
		set {
			setFlagBit(4, newValue)
		}
	}
	var DECIMAL : Bool {
		get {
			return (FLAGS & 8) == 8
		}
		set {
			setFlagBit(8, newValue)
		}
	}
	var BREAK : Bool {
		get {
			return (FLAGS & 16) == 16
		}
		set {
			setFlagBit(16, newValue)
		}
	}
	var OVERFLOW : Bool {
		get {
			return (FLAGS & 64) == 64
		}
		set {
			setFlagBit(64, newValue)
		}
	}
	var NEGATIVE : Bool {
		get {
			return (FLAGS & 128) == 128
		}
		set {
			setFlagBit(128, newValue)
		}
	}
}

extension CPU {
	func reset() {
		PC = 0xfffc
		SP = 0x00ff
		FLAGS = 0
		A = 0
		X = 0
		Y = 0
	}
}
