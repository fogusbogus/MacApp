import UIKit

var maze : [String] = [
	"WWWWWWWWWW",
	"W WW    WW",
	"* WW WW WW",
	"W W  W   W",
	"W   WW WWW",
	"WWWW W  WW",
	"+ WW WW WW",
	"W W   W  W",
	"W   W   WW",
	"WWWWWWWWWW",
]

func mazeWidth(maze: [String]) -> Int {
	guard let row = maze.first else {
		return 0
	}
	return row.count
}

enum CellType {
	case outOfBounds, blank, filled, startPosition, exit, wall
	
	static func fromSymbol(symbol: String) -> CellType {
		switch symbol {
			case CellType.outOfBounds.symbol:
				return .outOfBounds
			case CellType.blank.symbol:
				return .blank
			case CellType.filled.symbol:
				return .filled
			case CellType.startPosition.symbol:
				return .startPosition
			case CellType.exit.symbol:
				return .exit
			default:
				return .wall
		}
	}
	
	var symbol: String {
		get {
			switch self {
					
				case .outOfBounds:
					return "-"
				case .blank:
					return " "
				case .filled:
					return "."
				case .startPosition:
					return "+"
				case .exit:
					return "*"
				case .wall:
					return "W"
			}
		}
	}
}

func validXY(x: Int, y: Int, maze: [String]) -> CellType {
	guard x > 0, y > 0, maze.count > 0, x < mazeWidth(maze: maze), y < maze.count else { return .outOfBounds }
	if x == 0 || y == 0 || x == mazeWidth(maze: maze) - 1 || y == maze.count - 1 {
		return .exit
	}
	return CellType.fromSymbol(symbol: Array(maze[y]).map { String($0) }[x])
}

func find(maze: [String], findThis: CellType) -> (y: Int, x: Int) {
	var sp : (y: Int, x: Int) = (y: 0, x: -1)
	maze.forEach { line in
		if line.contains(findThis.symbol) {
			sp.x = line.map { String($0) }.firstIndex(of: findThis.symbol)!
		}
		if sp.x < 0 {
			sp.y += 1
		}
	}
	if sp.x < 0 {
		return (y: -1, x: -1)
	}
	return sp
}

//Let's start
var sp = find(maze: maze, findThis: CellType.startPosition)
//We've found the start position
print(sp)


