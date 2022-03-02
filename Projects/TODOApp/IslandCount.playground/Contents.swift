import Cocoa

/*
 This is a Google interview question for iOS (apparently).
 
 The solution reminds me of a flood fill algorithm when working with pixels. This takes me back to my youth of about 30-odd years ago where I would do similar things on an 8-bit micro. This is a bit faster.
 */

/// Remove an island (or a part of it) from a given map
/// - Parameters:
///   - map: The map we are working with
///   - x: Where we want to remove a piece of land
///   - y: Where we want to remove a piece of land
func removeIsland(_ map: inout [[String]], _ x: Int, _ y: Int) {
	//We must at least have a piece of land to remove
	guard map[y][x] == "1" else { return }
	
	//Remove the piece of land. As we are using recursion we don't need to record where we've been
	map[y][x] = "0"
	
	//Make some assumptions about the metrics of our map. We are assuming all secondary index counts are the same.
	let mapHeight = map.count
	let mapWidth = map.first?.count ?? 0
	
	//Let's get an array of possible locations to check next
	[(x-1,y-1), (x,y-1), (x+1,y-1), (x-1, y), (x+1,y), (x-1,y+1), (x,y+1), (x+1,y+1)].filter { xy in
		//We must use something within the bounds of our map array
		return xy.0 >= 0 && xy.0 < mapWidth && xy.1 >= 0 && xy.1 < mapHeight
	}.forEach { xy in
		//Now we can remove the pieces of land surrounding this piece of land
		removeIsland(&map, xy.0, xy.1)
	}
}

/// Count the number of islands within an array
/// - Parameter map: The map we are counting the islands from
/// - Returns: The number of islands on the map
func countIslands(_ map: [[String]]) -> Int {
	//We aren't changing the original map, but we do need a copy to manipulate
	var map = map
	
	//This will hold the number of islands
	var count = 0
	
	//Let's find the first instance of some land in our map
	while let locY = map.firstIndex(where: { line in
		return line.contains("1")
	}) {
		if let locX = map[locY].firstIndex(where: { col in
			return col == "1"
		}) {
			//We have found a piece of land. As we will be using some recursion to find any linked piece of land (and remove it) we can assume this is the first part of an island
			count += 1
			
			//This recursive function will remove the island from our local map (so it cannot be counted again)
			removeIsland(&map, locX, locY)
		}
		
	}
	return count
}

var grid = [
	["1", "1", "1", "1", "0"],
	["1", "1", "0", "1", "0"],
	["1", "1", "0", "0", "0"],
	["0", "0", "0", "0", "1"],
	["0", "0", "1", "0", "0"],
]

print(countIslands(grid))
print(grid)
