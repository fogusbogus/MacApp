import Foundation

func rollDie(_ currentNumber: Int) -> Int {
	return (1...6).filter { i in
		return i != currentNumber && i != (7 - currentNumber)
	}.randomElement()!
}

var currentNumber = Int.random(in: 1...6)
var allNumbers : [Int] = []
(0..<100).forEach { iter in
	allNumbers.append(currentNumber)
	currentNumber = rollDie(currentNumber)
}

print("\(allNumbers)")

