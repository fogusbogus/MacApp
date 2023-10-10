extension Double {
	func truncateAfterDecimalPlaces(_ places: Int) -> Self {
		var str = "\(self)"
		if let idx = str.ranges(of: ".").first {
			str += String(repeating: "0", count: places)
			str.removeSubrange(str.index(idx.lowerBound, offsetBy: places + 1)..<str.endIndex)
		}
		return Double(str) ?? self
	}
}

extension Float {
	func truncateAfterDecimalPlaces(_ places: Int) -> Self {
		var str = "\(self)"
		if let idx = str.ranges(of: ".").first {
			str += String(repeating: "0", count: places)
			str.removeSubrange(str.index(idx.lowerBound, offsetBy: places + 1)..<str.endIndex)
		}
		return Float(str) ?? self
	}
}

func going(_ n: Int) throws -> Double {
	// your code
	let a = 1.0 / factoral(n)
	var b = 1.0
	(2...n).forEach { b += factoral($0) }
	return (a * b).truncateAfterDecimalPlaces(6)
}

var calculatedFactorals: [Int:Double] = [:]

func tryFactoral(_ n: Int) throws -> Double {
	return factoral(n)
}

func factoral(_ n: Int) -> Double {
	if let c = calculatedFactorals[n] {
		return c
	}
	print(n)
	var ret = 1
	(2...n).forEach { value in
		ret *= value
	}
	calculatedFactorals[n] = Double(ret)
	return Double(ret)
}

func dotest(_ n: Int, _ expected: Double) throws {
	guard try going(n) == expected else { return }
}

do {
	//print(try tryFactoral(50))
	try dotest(5, 1.275)
	try dotest(6, 1.2125)
	try dotest(7, 1.173214)
	try dotest(8, 1.146651)
}
catch {
	print(error)
}



print(543453.394845.truncateAfterDecimalPlaces(2))
