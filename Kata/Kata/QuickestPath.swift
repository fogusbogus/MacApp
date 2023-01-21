//
//  QuickestPath.swift
//  Kata
//
//  Created by Matt Hogg on 19/01/2023.
//

import Foundation

class XY : Comparable, Hashable {
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(x)
		hasher.combine(y)
	}
	
	static func < (lhs: XY, rhs: XY) -> Bool {
		return "\(lhs.y)_\(lhs.x)" < "\(rhs.y)_\(rhs.x)"
	}
	
	static func == (lhs: XY, rhs: XY) -> Bool {
		return lhs.x == rhs.x && lhs.y == rhs.y
	}
	
	
	var x : Int
	var y : Int
	
	init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
	
	func offset(ox: Int, oy: Int) -> XY {
		return XY(x: x+ox, y: y+oy)
	}
}

class Grid
{
	private (set) var width : Int, height: Int
	
	subscript(xy: XY) -> String? {
		get {
			if xy.x < 0 || xy.y < 0 || xy.x >= width || xy.y >= height {
				return nil
			}
			return grid[xy.y][xy.x]
		}
		set {
			if xy.x < 0 || xy.y < 0 || xy.x >= width || xy.y >= height {
				return
			}
			grid[xy.y][xy.x] = newValue ?? "."
		}
	}
	
	var EndPoint : XY {
		return XY(x: width - 1, y: height - 1)
	}
	
	private var grid : [[String]]
	
	init(items: [[String]]) {
		grid = items
		height = grid.count
		width = grid.first?.count ?? 0
	}
	
	init(items: String) {
		grid = items.split(whereSeparator: {$0 == "\n"}).map({Array($0).map({String($0)})})
		height = grid.count
		width = grid.first?.count ?? 0
	}
}

class Finder {
	static func PathFinder(maze: String) -> Int {
		let grid = Grid(items: maze)
		
		var candidates : [XY] = [XY(x: 0, y: 0)]
		var checked : [XY] = []
		var moveCount = 0
		let endPoint = grid.EndPoint
		while true {
			if candidates.contains(where: {$0 == endPoint }) {
				return moveCount
			}
			var newCandidates : [XY] = []
			candidates.forEach { candidate in
				checked.append(candidate)
				//North
				if true {
					let newPt = candidate.offset(ox: 0, oy: -1)
					if !checked.contains(newPt) && (grid[newPt] ?? "") == "." {
						newCandidates.append(newPt)
					}
				}
				//East
				if true {
					let newPt = candidate.offset(ox: 1, oy: 0)
					if !checked.contains(newPt) && (grid[newPt] ?? "") == "." {
						newCandidates.append(newPt)
					}
				}
				//South
				if true {
					let newPt = candidate.offset(ox: 0, oy: 1)
					if !checked.contains(newPt) && (grid[newPt] ?? "") == "." {
						newCandidates.append(newPt)
					}
				}
				//West
				if true {
					let newPt = candidate.offset(ox: -1, oy: 0)
					if !checked.contains(newPt) && (grid[newPt] ?? "") == "." {
						newCandidates.append(newPt)
					}
				}
			}
			if newCandidates.count == 0 {
				return -1
			}
			moveCount += 1
			candidates = newCandidates.unique()
		}
	}
}

extension Sequence where Iterator.Element: Hashable {
	func unique() -> [Iterator.Element] {
		var seen: Set<Iterator.Element> = []
		return filter { seen.insert($0).inserted }
	}
}

/*

var a = ".W.\n" +
".W.\n" +
"..."

var b = ".W.\n" +
".W.\n" +
"W.."

var c = "......\n" +
"......\n" +
"......\n" +
"......\n" +
"......\n" +
"......"

var d = "......\n" +
"......\n" +
"......\n" +
"......\n" +
".....W\n" +
"....W."

print(Finder.PathFinder(maze: a))
print(Finder.PathFinder(maze: b))
print(Finder.PathFinder(maze: c))
print(Finder.PathFinder(maze: d))

*/
