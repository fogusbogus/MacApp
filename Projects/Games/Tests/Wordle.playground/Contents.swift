import Cocoa

enum WordleStatus {
	case correct, incorrect, wrongPlace, unknown
}

func WordleMatch(_ wordle: String, guess: String) -> [(String, WordleStatus)] {
	guard wordle.lengthOfBytes(using: .utf8) == guess.lengthOfBytes(using: .utf8) else {
		return []
	}
	
	let wordleArray = Array(wordle)
	var guessArray = Array(guess)
	var ret : [(String, WordleStatus)] = []
	guessArray.forEach { c in
		ret.append(("\(c)", .unknown))
	}
	for i in 0..<wordleArray.count {
		if guessArray[i] == wordleArray[i] {
			ret[i].1 = .correct
			guessArray[i] = " "
		}
	}
	guessArray = guessArray.filter({ c in
		return c != " "
	})
	
	//Let's see what's in the wrong position or not in there at all
	while let idx = ret.firstIndex(where: { $0.1 == .unknown }) {
		if let guessIndex = guessArray.firstIndex(of: wordleArray[idx]) {
			//Mark it as in the wrong place and remove the character from the guessArray pool as we don't want to repeat the search
			ret[idx].1 = .wrongPlace
			guessArray.remove(at: guessIndex)
		}
		else {
			ret[idx].1 = .incorrect
		}
	}
	return ret
}

print(WordleMatch("PEPPER", guess: "PIRPTA"))

