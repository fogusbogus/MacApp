import Foundation

public extension Array where Element == String {
	func match(_ regularExpression: String, _ defaultOptions: String.CompareOptions = [.caseInsensitive]) -> [String] {
		return self.filter { item in
			return item.range(of: regularExpression, options: [defaultOptions, .regularExpression]) != nil
		}
	}
	
	func containsImplied(_ findThis: String) -> Bool {
		return self.first { s in
			return s.range(of: findThis, options: .caseInsensitive) != nil
		} != nil
	}
	
}

public extension String {
	func implies(_ impliesThis: String) -> Bool {
		let mine = self.range(of: self)!
		if let found = self.range(of: impliesThis, options:.caseInsensitive) {
			return found.lowerBound == mine.lowerBound && found.upperBound == mine.upperBound
		}
		return false
	}

}

public enum NextWordCandidateError: Error {
	case invalidWord
}

public class NextWordCandidate {
	private(set) var word: String
	private(set) var pattern: String
	private(set) var candidates: [String]
	
	init(word: String, dictionary: [String], caseless: Bool = true) throws {
		if word.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0 {
			throw NextWordCandidateError.invalidWord
		}
		
		let chars = Array(word.trimmingCharacters(in: .whitespacesAndNewlines))
		var pat = "("
		for i in 0..<chars.count {
			if i > 0 {
				pat += ")|("
			}
			for i2 in 0..<chars.count {
				pat += "[" + (i == i2 ? "^" : "") + "\(chars[i2])]"
			}
		}
		pat += ")"
		self.word = word
		self.pattern = pat
		let options : String.CompareOptions = caseless ? String.CompareOptions.caseInsensitive : []
		self.candidates = dictionary.match(pat, options)
	}
}

public enum NextWordCalculatorError : String, Error {
	case invalidConfiguration = "The configuration passed is either null or invalid"
	case invalidDictionary = "The dictionary passed is nil"
	case emptyDictionary = "The dictionary passed is empty"
	case invalidStartWord = "The start word is invalid"
	case invalidEndWord = "The end word is invalid"
	case indifferentStartAndEndWords = "The start and end words are the same!"
	case startWordNotInDictionary = "The start word must appear in the dictionary"
	case endWordNotInDictionary = "The end word must appear in the dictionary"
	case mismatchedLengths = "The start and end words must have the same length"
	
	var message: String {
		get {
			return self.rawValue
		}
	}
}

public class NextWordCalculator {
	public init() {
		
	}

	
	private func getPaths(dictionary: [String], currentPath: [String], endWord: String, patterns: [NextWordCandidate]) -> [[String]] {
		let lastWord = currentPath.last!
		print("lastWord: \(lastWord)")
		let cPattern = patterns.first { p in
			return p.word.implies(lastWord)
		}
		let candidates = patterns.first { pattern in
			return pattern.word.implies(lastWord)
		}?.candidates.filter({ s in
			return !currentPath.containsImplied(s)
		})
		print(candidates)
		var ret : [[String]] = []
		candidates?.forEach({ candidate in
			var c = currentPath
			c.append(candidate)
			ret.append(c)
			
		})
		return ret
	}
	
	public func CalculatePaths(dictionary: [String], startWord: String, endWord: String) throws -> [[String]] {
		let dictionary = dictionary.filter { s in
			return !s.isEmptyOrWhitespace()
		}
		if dictionary.count == 0 {
			throw NextWordCalculatorError.emptyDictionary
		}
		
		if startWord.isEmptyOrWhitespace() {
			throw NextWordCalculatorError.invalidStartWord
		}
		if endWord.isEmptyOrWhitespace() {
			throw NextWordCalculatorError.invalidEndWord
		}
		
		
		if !dictionary.containsImplied(startWord) {
			throw NextWordCalculatorError.startWordNotInDictionary
		}

		if !dictionary.containsImplied(endWord) {
			throw NextWordCalculatorError.endWordNotInDictionary
		}
		
		if startWord.implies(endWord) {
			throw NextWordCalculatorError.indifferentStartAndEndWords
		}
		
		if startWord.lengthOfBytes(using: .utf8) != endWord.lengthOfBytes(using: .utf8) {
			throw NextWordCalculatorError.mismatchedLengths
		}
		
		var words = Array(Set(dictionary)).filter { s in
			return s.lengthOfBytes(using: .utf8) == startWord.lengthOfBytes(using: .utf8)
		}
		
		var patterns: [NextWordCandidate] = []
		try words.forEach { word in
				try patterns.append(NextWordCandidate(word: word, dictionary: words))
		}
		
		var candidates : [Int:[String]] = [:]
		candidates[0] = [startWord]
		var newIndex = 1
		var currentIteration = 1
		
		print("Looking at candidates")
		print("\(candidates.count)")
		while candidates.first(where: { keyValue in
			return keyValue.value.containsImplied(endWord)
		}) == nil && candidates.count > 0 {
			print("Iteration \(currentIteration) - collection contains \(candidates.count) entry/entries")
			currentIteration += 1
			var newAndUpdatedEntries : [Int:[String]] = [:]
			var toRemove : [Int] = []
			candidates.forEach { candidate in
				//print(candidate)
				print("Getting paths")
				let paths = getPaths(dictionary: words, currentPath: candidate.value, endWord: endWord, patterns: patterns)
				if paths.count == 0 {
					toRemove.append(candidate.key)
				}
				else {
					newAndUpdatedEntries[candidate.key] = paths.first!
				}
				
				var first = true
				paths.forEach { pathItems in
					if !first {
						newAndUpdatedEntries[newIndex] = pathItems
						newIndex += 1
					}
					else {
						first = false
					}
				}
			}
			toRemove.forEach { i in
				candidates.removeValue(forKey: i)
			}
			newAndUpdatedEntries.forEach { kv in
				candidates[kv.key] = kv.value
			}
		}
		return candidates.filter { kv in
			return kv.value.containsImplied(endWord)
		}.map { kv in
			return kv.value
		}
	}
}

public extension String {
	func isEmptyOrWhitespace() -> Bool {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) == 0
	}
}
