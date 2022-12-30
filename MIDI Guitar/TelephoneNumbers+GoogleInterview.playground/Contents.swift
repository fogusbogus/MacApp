import UIKit


///River lengths problem
///

func travel(x: Int, y: Int, count: Int, map: [[Int]]) -> (count: Int, map: [[Int]]) {
	
	// Make sure we are inside the map boundaries
	guard x >= 0 && x < map.first!.count && y >= 0 && y < map.count else { return (count: count, map: map) }
	
	guard map[y][x] == 1 else { return (count: count, map: map) }
	
	// Mark the river position as visited - we don't want to come back to this and count it again
	var map = map
	map[y][x] = -1
	var count = count + 1
	
	// Do all 4 main compass directions and update the count and map - we're relying on recursion to exhaust the river length
	(count, map) = travel(x: x + 1, y: y, count: count, map: map)
	(count, map) = travel(x: x - 1, y: y, count: count, map: map)
	(count, map) = travel(x: x, y: y - 1, count: count, map: map)
	(count, map) = travel(x: x, y: y + 1, count: count, map: map)
	
	//We should have a length calculation
	return (count: count, map: map)
}


/// Given a matrix of land/river values (0/1), we need to find the position of a 1. minus 1 denotes a visited river area.
/// - Parameter map: Map matrix
/// - Returns: Position of a 1 value. If not present the values are nil.
func getRiverPosition(map: [[Int]]) -> (x: Int?, y: Int?) {
	let w = map.first?.count ?? 0
	let h = map.count
	guard w > 0 && h > 0 else { return (x: nil, y: nil) }
	
	if let idx = map.flatMap({$0}).firstIndex(of: 1) {
		return (x: idx % w, y: idx / w)
	}
	return (x: nil, y: nil)
}

/// Given a matrix, how many rivers are there?
/// - Parameter map: Map matrix of land (0) or river (1)
/// - Returns: <#description#>
func countRivers(map: [[Int]]) -> [Int] {
	var ret : [Int] = []
	var map = map
	
	// Find an unvisited river part
	var (x,y) = getRiverPosition(map: map)
	while x != nil && y != nil {
		// Count and add the river length
		var (count, newMap) = travel(x: x!, y: y!, count: 0, map: map)
		map = newMap
		ret.append(count)
		
		// Because the river length search is exhausted, we need to find ourselves a new river!
		(x,y) = getRiverPosition(map: map)
	}
	
	// The solution would like the array sorted for testing
	return ret.sorted()
}

let map = [
	[1, 0, 0, 1, 0],
	[1, 0, 1, 0, 0],
	[0, 0, 1, 0, 1],
	[1, 0, 1, 0, 1],
	[1, 0, 1, 1, 0]
]


print(countRivers(map: map))


///telephone numbers problem
//var numToLetters : [Int:String] = [
//	0:"0",
//	1:"1",
//	2:"2abc",
//	3:"3def",
//	4:"4ghi",
//	5:"5jkl",
//	6:"6mno",
//	7:"7pqrs",
//	8:"8tuv",
//	9:"9xyz"
//]
//
//
//func wordToNumber(word: String) -> String {
//	//assume the word only contains valid letters and or numbers
//	return word.map { chr in
//		return "\(numToLetters.first { $0.value.contains(chr.lowercased()) }!.key)"
//	}.joined()
//}
//
//func wordsInNumber(number: String, words: [String]) -> [String] {
//	var ret : [String] = []
//	words.forEach { word in
//		if number.contains(wordToNumber(word: word)) {
//			ret.append(word)
//		}
//	}
//	return ret.sorted()
//}
//
//
//let words = ["foo", "bar", "baz", "foobar", "emo", "cap", "car", "cat"]
//
//print(wordsInNumber(number: "3662277", words: words))
//
