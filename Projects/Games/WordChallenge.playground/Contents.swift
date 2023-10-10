import Cocoa

var dict : [String] = ["test", "tent", "rest", "rent", "tint", "ting", "rant", "ping", "pint", "pant"]

func getCharacterChangeCount(_ word: String, _ other: String) -> Int {
	var wordChars = Array(other)
	word.forEach { c in
		if let idx = wordChars.firstIndex(of: c) {
			wordChars.remove(at: idx)
		}
	}
	return wordChars.count
}

func getSingleChangePaths(words: [String], from: String) -> [String] {
	return words.filter { s in
		return getCharacterChangeCount(s, from) == 1
	}
}

func getPaths(words: [String], path: [String], endWord: String) -> [[String]] {
	let candidates = getSingleChangePaths(words: words.filter { s in
		return !path.contains(s)
	}, from: path.last!)
	
	if candidates.contains(endWord) {
		var path = path
		path.append(endWord)
		return [path]
	}
	
	if candidates.count == 0 {
		return []
	}
	
	var ret : [[String]] = []
	
	candidates.forEach { candidate in
		var path = path
		path.append(candidate)
		let valid = getPaths(words: words, path: path, endWord: endWord)
		if valid.count > 0 {
			ret.append(contentsOf: valid)
		}
	}
	return ret
}

func describeWordChallengeArray(words: [String]) -> String {
	return words.joined(separator: " -> ")
}

func getTextMatches(_ array: [String], _ find: String) -> [String] {
	return array.filter { item in
		return item.range(of: find, options: [.caseInsensitive, .regularExpression]) != nil
	}
}

let nwc = NextWordCalculator()
print(dict)
do {
	try print(nwc.CalculatePaths(dictionary: dict, startWord: "test", endWord: "ping"))
}
catch let error {
	print("E: \(error)")
}


//print(dict.match(pattern))

//print("\nCandidates:")
//let paths = getPaths(words: dict, path: ["test"], endWord: "ping")
//paths.forEach { path in
//	print(describeWordChallengeArray(words: path))
//}
//
//print("\nWinner(s):")
//let minPathCount = paths.min { a1, a2 in
//	return a1.count < a2.count
//}?.count ?? 0
//
//paths.filter({ array in
//	return array.count == minPathCount
//}).forEach({ path in
//	print(describeWordChallengeArray(words: path))
//})
