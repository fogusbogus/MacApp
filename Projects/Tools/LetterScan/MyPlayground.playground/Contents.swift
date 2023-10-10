import Cocoa
import ImageCaptureCore
import Foundation

class CPU {
	
	typealias LineNumber = Int
	
	init() {
		//Z80 for example
		registers["a"] = 0
		registers["b"] = 0
		registers["c"] = 0
		registers["d"] = 0
		registers["e"] = 0
		registers["h"] = 0
		registers["l"] = 0
	}
	
	private var registers : [String:Int]
	private var instructions: [String]
	private var labels: [String:Int]
	
	enum Errors : Error {
		case syntax(line: String)
		case invalidRegister(register: String)
		case invalidValue(value: String)
		case invalidLineNumber(lineNo: Int)
		case invalidLabel(label: String)
	}
	
	private func validRegister(register: String) -> Bool {
		return registers.keys.contains(register.lowercased())
	}
	
	public func interpret(lineNo: LineNumber) throws -> LineNumber {
		guard lineNo >= 0 && lineNo < instructions.count else {
			throw Errors.invalidLineNumber(lineNo: lineNo)
		}
		
		let parts = instructions[lineNo].components(separatedBy: .whitespaces).compactMap { s in
			return s == "" ? nil : s
		}
		switch parts[0].lowercased() {
			case "mov":
				return try lineNo + mov(parts: parts)
			default:
				if parts.count > 0 {
					if parts[0].hasSuffix(":") {
						//This is a label
						let name = parts[0].prefix(upTo: parts[0].firstIndex(of: ":")!)
						labels[name.lowercased()] = lineNo
					}
				}
				throw Errors.syntax(line: instructions[lineNo])
		}
	}
}

extension CPU {
	func mov(parts: [String]) throws -> Int {
		if parts.count > 2 {
			let source = parts[1].lowercased()
			let dest = parts[2]
			if !validRegister(register: source) {
				throw Errors.invalidRegister(register: source)
			}
			if let destValue = Int(dest) {
				if !(0...255).contains(destValue) {
					throw Errors.invalidValue(value: dest)
				}
				registers[source] = destValue
				return 1
			}
			else {
				if !validRegister(register: dest) {
					throw Errors.invalidRegister(register: dest)
				}
				registers[source.lowercased()] = registers[dest.lowercased()]
				return 1
			}
		}
		else {
			throw Errors.syntax(line: parts.joined(separator: " "))
		}
	}
	
	func inc(parts: [String]) throws -> Int {
		if parts.count > 1 {
			//Second part must be a valid register
			let reg = parts[1].lowercased()
			if !validRegister(register: reg) {
				throw Errors.invalidRegister(register: reg)
			}
			registers[reg]! += 1
			return 1
		}
		else {
			throw Errors.syntax(line: parts.joined(separator: " "))
		}
	}
	func dec(parts: [String]) throws -> Int {
		if parts.count > 1 {
			//Second part must be a valid register
			let reg = parts[1].lowercased()
			if !validRegister(register: reg) {
				throw Errors.invalidRegister(register: reg)
			}
			registers[reg]! -= 1
			return 1
		}
		else {
			throw Errors.syntax(line: parts.joined(separator: " "))
		}
	}
	
	func jz(parts: [String]) throws -> Int {
		
	}
}
