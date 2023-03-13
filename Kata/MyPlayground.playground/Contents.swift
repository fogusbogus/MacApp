import Foundation



class Compiler {
	
	enum Errors: Error {
		case noSuchFile(path: String)
		case labelAlreadyDefined(label: String, lineNo: Int)
		case unknown(text: String, lineNo: Int)
		case missingLabel(label: String)
	}
	
	var cpu: CPU = CPU()
	var labelIndex: [String:Int] = [:]
	var program: [String] = []
	var callStack: [Int] = []
	
	func parse(_ program: String) throws {
		try parse(program.split(separator: "\n").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}))
	}
	
	func parse(_ lines: [String]) throws {
		var requiredLabels: [String] = []
		var lineNo = 0
		while lineNo < lines.count {
			program.append(lines[lineNo])
			let item = try CPUCommand.instructionType(lines[lineNo])
			switch item {
				case .addValue(let register, _):
					cpu.assertRegister(register)
				case .addRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .dec(let register):
					cpu.assertRegister(register)
				case .inc(let register):
					cpu.assertRegister(register)
				case .subValue(let register, _):
					cpu.assertRegister(register)
				case .subRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .movValue(let register, _):
					cpu.assertRegister(register)
				case .movRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .mulValue(let register, _):
					cpu.assertRegister(register)
				case .mulRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .divValue(let register, _):
					cpu.assertRegister(register)
				case .divRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .cmpValue(let register, _):
					cpu.assertRegister(register)
				case .cmpRegister(let register, let other):
					cpu.assertRegister(register)
					cpu.assertRegister(other)
				case .jmp(let label):
					requiredLabels.assert(label)
				case .jz(let label):
					requiredLabels.assert(label)
				case .jnz(let label):
					requiredLabels.assert(label)
				case .je(let label):
					requiredLabels.assert(label)
				case .jne(let label):
					requiredLabels.assert(label)
				case .jle(let label):
					requiredLabels.assert(label)
				case .jge(let label):
					requiredLabels.assert(label)
				case .jl(let label):
					requiredLabels.assert(label)
				case .jg(let label):
					requiredLabels.assert(label)
				case .ret:
					break
				case .call(let label):
					requiredLabels.assert(label)
				case .msg(_, let register):
					cpu.assertRegister(register)
				case .end:
					break
				case .comment(_):
					break
				case .label(let label):
					if labelIndex.keys.contains(label) {
						throw Errors.labelAlreadyDefined(label: label, lineNo: lineNo)
					}
					labelIndex[label] = lineNo
				case .empty:
					break
				case .unknown(let text):
					throw Errors.unknown(text: text, lineNo: lineNo)
			}
			lineNo += 1
		}
		if let unknownLabel = requiredLabels.filter({!labelIndex.keys.contains($0)}).first {
			throw Errors.missingLabel(label: unknownLabel)
		}
	}
	
	func processLine(_ lineNo: Int, msg: inout String) -> Int? {
		if lineNo >= program.count {
			return nil
		}
		let item = try! CPUCommand.instructionType(program[lineNo])
		switch item {
			case .addValue(let register, let value):
				cpu.add(register: register, value: value)
			case .addRegister(let register, let other):
				cpu.add(register: register, valueFromRegister: other)
			case .dec(let register):
				cpu.sub(register: register, value: 1)
			case .inc(let register):
				cpu.add(register: register, value: 1)
			case .subValue(let register, let value):
				cpu.sub(register: register, value: value)
			case .subRegister(let register, let other):
				cpu.sub(register: register, valueFromRegister: other)
			case .movValue(let register, let value):
				cpu.move(register: register, value: value)
			case .movRegister(let register, let other):
				cpu.move(register: register, valueFromRegister: other)
			case .mulValue(let register, let value):
				cpu.mult(register: register, value: value)
			case .mulRegister(let register, let other):
				cpu.mult(register: register, valueFromRegister: other)
			case .divValue(let register, let value):
				cpu.div(register: register, value: value)
			case .divRegister(let register, let other):
				cpu.div(register: register, valueFromRegister: other)
			case .cmpValue(let register, let value):
				cpu.cmp(register: register, value: value)
			case .cmpRegister(let register, let other):
				cpu.cmp(register: register, valueFromRegister: other)
			case .jmp(let label):
				return labelIndex[label]!
			case .jz(let label):
				if cpu.zero {
					return labelIndex[label]!
				}
				
			case .jnz(let label):
				if !cpu.zero {
					return labelIndex[label]!
				}
				
			case .je(let label):
				if cpu.equal {
					return labelIndex[label]!
				}
				
			case .jne(let label):
				if !cpu.equal {
					return labelIndex[label]!
				}
				
			case .jle(let label):
				if cpu.less || cpu.equal {
					return labelIndex[label]!
				}
				
			case .jge(let label):
				if cpu.greater || cpu.equal {
					return labelIndex[label]!
				}
				
			case .jl(let label):
				if cpu.less {
					return labelIndex[label]!
				}
				
			case .jg(let label):
				if cpu.greater {
					return labelIndex[label]!
				}
				
			case .ret:
				return callStack.popLast()
			case .call(let label):
				callStack.append(lineNo + 1)
				return labelIndex[label]!
				
			case .msg(let text, let register):
				print(text)
				print(register)
				msg = "\(text) = \(cpu.registers[register]!.value)"
			case .end:
				return nil
			case .comment(_):
				break
			case .label(_):
				break
			case .unknown(_):
				break
			case .empty:
				break
		}
		return lineNo + 1
	}
	
	init() {
	}
}

class CPU : RegisterHandler {
	
	var carry: Bool = false
	var zero: Bool = true
	var equal: Bool = false
	var less: Bool = false
	var greater: Bool = false
	
	func setCarry() {
		carry = true
	}
	
	func setZero() {
		zero = true
	}
	
	func setNotZero() {
		zero = false
	}
	
	
	var registers : [String:Register] = [:]
	
	func assertRegister(_ register: String) {
		if !registers.keys.contains(register) {
			registers[register] = Register(0, self)
		}
	}
	
	
}

//Move functions
extension CPU {
	public func move(register: String, value: Int) {
		registers[register]!.value = value
	}
	public func move(register: String, valueFromRegister: String) {
		move(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}

//Add functions
extension CPU {
	public func add(register: String, value: Int) {
		registers[register]!.value += value
	}
	
	public func add(register: String, valueFromRegister: String) {
		add(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}

//Sub functions
extension CPU {
	public func sub(register: String, value: Int) {
		registers[register]!.value -= value
	}
	
	public func sub(register: String, valueFromRegister: String) {
		sub(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}

//Mult functions
extension CPU {
	public func mult(register: String, value: Int) {
		registers[register]!.value *= value
	}
	
	public func mult(register: String, valueFromRegister: String) {
		mult(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}

//Div functions
extension CPU {
	public func div(register: String, value: Int) {
		guard value != 0 else { return }
		registers[register]!.value /= value
	}
	
	public func div(register: String, valueFromRegister: String) {
		div(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}

//Cmp functions
extension CPU {
	public func cmp(register: String, value: Int) {
		guard let reg = registers[register] else { return }
		equal = reg.value == value
		less = value < reg.value
		greater = value > reg.value
	}
	
	public func cmp(register: String, valueFromRegister: String) {
		cmp(register: register, value: registers[valueFromRegister]?.value ?? 0)
	}
}


class Register {
	var value: Int = 0 {
		didSet {
			if value < 0 || value > 255 {
				delegate.setCarry()
			}
			while value < 0 {
				value = 256 + value
			}
			value = value % 256
			if value == 0 {
				delegate.setZero()
			}
			else {
				delegate.setNotZero()
			}
			
		}
	}
	var delegate: RegisterHandler
	
	init(_ delegate: RegisterHandler) {
		self.value = 0
		self.delegate = delegate
	}
	init(_ value: Int, _ delegate: RegisterHandler) {
		self.value = value
		self.delegate = delegate
	}
}

protocol RegisterHandler {
	func setCarry()
	func setZero()
	func setNotZero()
}

extension Array where Element == String {
	mutating func assert(_ value: String) {
		if !self.contains(value) {
			self.append(value)
		}
	}
}

enum CPUCommandErrors: Error {
	case syntax
}

enum CPUCommand {
	case addValue(register: String, value: Int)
	case addRegister(register: String, other: String)
	case dec(register: String)
	case inc(register: String)
	case subValue(register: String, value: Int)
	case subRegister(register: String, other: String)
	case movValue(register: String, value: Int)
	case movRegister(register: String, other: String)
	case mulValue(register: String, value: Int)
	case mulRegister(register: String, other: String)
	case divValue(register: String, value: Int)
	case divRegister(register: String, other: String)
	case cmpValue(register: String, value: Int)
	case cmpRegister(register: String, other: String)
	case jmp(label: String)
	case jz(label: String)
	case jnz(label: String)
	case je(label: String)
	case jne(label: String)
	case jle(label: String)
	case jge(label: String)
	case jl(label: String)
	case jg(label: String)
	case ret
	case call(label: String)
	case msg(text: String, register: String)
	case end
	case comment(text: String)
	case label(label: String)
	case unknown(text: String)
	case empty
	
	static func instructionType(_ value: String) throws -> CPUCommand {
		guard !value.isEmptyOrWhitespace() else { return .empty }
		var parts = value.components(separatedBy: .whitespaces).filter({!$0.isEmptyOrWhitespace()})
		if parts.contains(";") {
			while parts.last != ";" {
				parts.removeLast()
			}
			parts.removeLast()
		}
		
		if parts.count == 0 {
			return .empty
		}
		
		switch parts.first {
			case "add":
				
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .addValue(register: parts[1].asRegister(), value: num)
				}
				return .addRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "dec":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .dec(register: parts[1].asRegister())
			case "inc":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .inc(register: parts[1].asRegister())
			case "sub":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .subValue(register: parts[1].asRegister(), value: num)
				}
				return .subRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "mov":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .movValue(register: parts[1].asRegister(), value: num)
				}
				return .movRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "mul":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .mulValue(register: parts[1].asRegister(), value: num)
				}
				return .mulRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "div":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .divValue(register: parts[1].asRegister(), value: num)
				}
				return .divRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "cmp":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				if let num = Int(parts[2]) {
					return .cmpValue(register: parts[1].asRegister(), value: num)
				}
				return .cmpRegister(register: parts[1].asRegister(), other: parts[2])
				
			case "jmp":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jmp(label: parts[1])
			case "jz":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jz(label: parts[1])
			case "jnz":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jnz(label: parts[1])
			case "je":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .je(label: parts[1])
			case "jne":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jne(label: parts[1])
			case "jle":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jle(label: parts[1])
			case "jge":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jge(label: parts[1])
			case "jl":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jl(label: parts[1])
			case "jg":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .jg(label: parts[1])
			case "ret":
				return .ret
			case "call":
				if parts.count < 2 {
					throw CPUCommandErrors.syntax
				}
				return .call(label: parts[1])
			case "msg":
				if parts.count < 3 {
					throw CPUCommandErrors.syntax
				}
				let reg = parts.removeLast()
				var allParts = parts
				allParts.removeFirst()
				allParts.removeLast()
				allParts[0].removeFirst()
				allParts[allParts.count - 1].removeLast()
				allParts[allParts.count - 1].removeLast()
				return .msg(text: parts.joined(separator: " "), register: reg)
			case "end":
				return .end
			default:
				
				if parts.count > 0 && parts[0].hasSuffix(":") {
					return .label(label: parts[0].replacingOccurrences(of: ":", with: ""))
				}
				return .unknown(text: parts.joined(separator: " "))
		}
	}
}


extension String {
	func asRegister() -> String {
		return self.replacingOccurrences(of: ",", with: "")
	}
	
	func isEmptyOrWhitespace() -> Bool {
		return self.isEmpty || self.trimmingCharacters(in: .whitespaces).isEmpty
	}
}

func assemblerInterpreter(_ program:String) throws -> String {
	/*
	 *  The swift version of this kata differs from the description slightly:
	 *  instead of returning an interger -1 value on error the program should
	 *  throw an error instead. This uses all the same sample test programs
	 *  as the javascript version of this kata but they have all been placed
	 *  on a single line since swift version 3 which the site uses does
	 *  not support multiple-line literal strings.
	 */
	let cp = Compiler()
	try cp.parse(program)
	
	var ln : Int? = 0
	var msg = ""
	while let _ = ln {
		ln = cp.processLine(ln!, msg: &msg)
	}
	return msg
}

var examplePrograms = [["; My first program\nmov  a, 5\ninc  a\ncall function\nmsg  \'(5+1)/2 = \', a    ; output message\nend\n\nfunction:\n    div  a, 2\n    ret", "(5+1)/2 = 3"], ["mov   a, 5\nmov   b, a\nmov   c, a\ncall  proc_fact\ncall  print\nend\n\nproc_fact:\n    dec   b\n    mul   c, b\n    cmp   b, 1\n    jne   proc_fact\n    ret\n\nprint:\n    msg   a, \'! = \', c ; output text\n    ret", "5! = 120"], ["mov   a, 8            ; value\nmov   b, 0            ; next\nmov   c, 0            ; counter\nmov   d, 0            ; first\nmov   e, 1            ; second\ncall  proc_fib\ncall  print\nend\n\nproc_fib:\n    cmp   c, 2\n    jl    func_0\n    mov   b, d\n    add   b, e\n    mov   d, e\n    mov   e, b\n    inc   c\n    cmp   c, a\n    jle   proc_fib\n    ret\n\nfunc_0:\n    mov   b, c\n    inc   c\n    jmp   proc_fib\n\nprint:\n    msg   \'Term \', a, \' of Fibonacci series is: \', b        ; output text\n    ret", "Term 8 of Fibonacci series is: 21"], ["mov   a, 11           ; value1\nmov   b, 3            ; value2\ncall  mod_func\nmsg   \'mod(\', a, \', \', b, \') = \', d        ; output\nend\n\n; Mod function\nmod_func:\n    mov   c, a        ; temp1\n    div   c, b\n    mul   c, b\n    mov   d, a        ; temp2\n    sub   d, c\n    ret", "mod(11, 3) = 2"], ["mov   a, 81         ; value1\nmov   b, 153        ; value2\ncall  init\ncall  proc_gcd\ncall  print\nend\n\nproc_gcd:\n    cmp   c, d\n    jne   loop\n    ret\n\nloop:\n    cmp   c, d\n    jg    a_bigger\n    jmp   b_bigger\n\na_bigger:\n    sub   c, d\n    jmp   proc_gcd\n\nb_bigger:\n    sub   d, c\n    jmp   proc_gcd\n\ninit:\n    cmp   a, 0\n    jl    a_abs\n    cmp   b, 0\n    jl    b_abs\n    mov   c, a            ; temp1\n    mov   d, b            ; temp2\n    ret\n\na_abs:\n    mul   a, -1\n    jmp   init\n\nb_abs:\n    mul   b, -1\n    jmp   init\n\nprint:\n    msg   \'gcd(\', a, \', \', b, \') = \', c\n    ret", "gcd(81, 153) = 9"], ["mov   a, 2            ; value1\nmov   b, 10           ; value2\nmov   c, a            ; temp1\nmov   d, b            ; temp2\ncall  proc_func\ncall  print\nend\n\nproc_func:\n    cmp   d, 1\n    je    continue\n    mul   c, a\n    dec   d\n    call  proc_func\n\ncontinue:\n    ret\n\nprint:\n    msg a, \'^\', b, \' = \', c\n    ret", "2^10 = 1024"]]

examplePrograms.forEach { prog in
	let code = prog[0]
	let res = prog[1]
	do {
		let actual = try assemblerInterpreter(code)
		if actual != res {
			print("Actual: \(actual)")
			print("Expect: \(res)")
		}
	}
	catch {
		print(error)
	}
}
