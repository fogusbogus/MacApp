import Cocoa

class GridSquare {
	public var linkedSquares : [GridSquare] = []
	public var isBomb = false
	public var isRevealed = false
	public var isMarked = false
	public var symbol : String {
		get {
			if !isRevealed {
				return isMarked ? "⛳️" : " "
			}
			if isMarked {
				return "⛳️"
			}
			if isBomb {
				return "💣"
			}
			
			//Let's count bombs around us
			let count = linkedSquares.filter { gs in
				return gs.isBomb
			}.count
			return count == 0 ? " " : "\(count)"
		}
	}
	
	func isBlank() -> Bool {
		if isBomb || isMarked {
			return false
		}
		return linkedSquares.filter { gs in
			return gs.isBomb
		}.count == 0
	}
	
	func reveal() {
		if isRevealed {
			return
		}
		isRevealed = true
		if isBlank() {
			linkedSquares.forEach { gs in
				gs.reveal()
			}
		}
	}
}

class Grid {
	var height = 24, width = 24
	
	var _grid : [GridSquare] = []
	var grid : [GridSquare] {
		get {
			let count = _grid.count
			if count == 0 {
				(0..<height*width).forEach { i in
					_grid.append(GridSquare())
				}
				(0..<height).forEach { y in
					(0..<width).forEach { x in
						let square = grid[y * width + x]
						if y > 0 {
							let ym1 = y-1
							square.linkedSquares.append(grid[ym1 * width - x])
							if x > 0 {
								square.linkedSquares.append(grid[ym1 * width + x - 1])
							}
							if x < width - 1 {
								square.linkedSquares.append(grid[ym1 * width + x + 1])
							}
							
						}
						if y == y	{
							if x > 0 {
								square.linkedSquares.append(grid[y * width + x - 1])
							}
							if x < self.width - 1 {
								square.linkedSquares.append(grid[y * width + x + 1])
							}
						}
						if y < height - 1 {
							let ym1 = y+1
							square.linkedSquares.append(grid[ym1 * width - x])
							if x > 0 {
								square.linkedSquares.append(grid[ym1 * width + x - 1])
							}
							if x < width - 1 {
								square.linkedSquares.append(grid[ym1 * width + x + 1])
							}
						}
					}
				}
			}
			return _grid
		}
	}

	func fillWithBombs(firstMoveX: Int, firstMoveY: Int, numberOfBombs: Int) {
		let moveIdx = firstMoveY * width + firstMoveX
		(0..<numberOfBombs).forEach { bombNo in
			var idx = Int.random(in: 0..<height * width)
			while idx == moveIdx || !grid[idx].isBlank() {
				idx = Int.random(in: 0..<height * width)
			}
			grid[idx].isBomb = true
		}
		grid[moveIdx].reveal()
	}
	
	func asString() -> String {
		var ret = ""
		var i = 0
		(0..<height).forEach { y in
			(0..<width).forEach { x in
				ret += grid[i].symbol
				i += 1
			}
			ret += "\n"
		}
		return ret
	}
}

func setMapBomb(array: inout [Int], height: Int, width: Int, index: Int) {
	array[index] = -1
	(-1...1).forEach { y in
		(-1...1).forEach { x in
			if x * y != 0 {
				let i = index + y * width + x
				if i >= 0 && i < height * width {
					if array[i] >= 0 {
						array[i] = array[i] + 1
					}
				}
			}
		}
	}
}

var grid = Grid()

grid.fillWithBombs(firstMoveX: 10, firstMoveY: 5, numberOfBombs: 20)

print(grid.asString())

