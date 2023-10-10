//
//  Conway2.swift
//  ConwayApp
//
//  Created by Matt Hogg on 04/10/2022.
//

import Foundation

struct Cell : Hashable {
	var y : Int
	var x : Int
	
	init(y: Int, x: Int) {
		self.y = y
		self.x = x
	}
	
	init(_ altY: Int, _ altX: Int) {
		self.y = altY
		self.x = altX
	}
}

class CellArray2 : ObservableObject {
	
	typealias Cells = [Cell]
	
	@Published var update: Bool = false
	
	private var aliveCells : Cells = []
	
	init(cells: [[Int]]) {
		let h = cells.count
		let w = cells.first!.count

		(0..<h).forEach { y in
			(0..<w).forEach { x in
				if cells[y][x] == 1 {
					aliveCells.append(Cell(y,x))
				}
			}
		}
	}
	
	private func metrics(cells: Cells) -> (top: Int, bottom: Int, left: Int, right: Int) {
		return (cells.map {$0.y}.min() ?? 0, cells.map {$0.y}.max() ?? 0, cells.map {$0.x}.min() ?? 0, cells.map {$0.x}.max() ?? 0)
	}
	
	func render(_ cells: Cells? = nil) -> [[Int]] {
		
		let cells = cells ?? aliveCells
	
		let metrics = metrics(cells: cells)
		let offY = -metrics.top
		let offX = -metrics.left

		let width = 1 + metrics.right - metrics.left
		let height = 1 + metrics.bottom - metrics.top
		
		var ret = Array(repeating: Array(repeating: 0, count: width), count: height)
		cells.forEach { xy in
			ret[xy.y + offY][xy.x + offX] = 1
		}
		return ret
	}
	
	func getSurroundingCells(y: Int, x: Int, cells: Cells? = nil) -> Cells {
		let cells = cells ?? aliveCells
		
		let range : [(y: Int, x: Int)] = [
			(y-1,x-1), (y-1,x), (y-1,x+1),
			(y  ,x-1),          (y  ,x+1),
			(y+1,x-1), (y+1,x), (y+1,x+1)
		]
		return cells.filter { yx in
			return range.contains { ryx in
				return ryx.y == yx.y && ryx.x == yx.x
			}
		}
	}
	
	@discardableResult
	func generate(_ cells: Cells? = nil) -> Cells {
		var newAliveCells: Cells = []
		let cells = cells ?? aliveCells
		
		let metrics = metrics(cells: cells)

		var cellsToTry: Cells = []
		
		cells.forEach { cell in
			cellsToTry.append(Cell(cell.y-1,cell.x-1))
			cellsToTry.append(Cell(cell.y-1,cell.x))
			cellsToTry.append(Cell(cell.y-1,cell.x+1))
			cellsToTry.append(Cell(cell.y,cell.x-1))
			cellsToTry.append(Cell(cell.y,cell.x))
			cellsToTry.append(Cell(cell.y,cell.x+1))
			cellsToTry.append(Cell(cell.y+1,cell.x-1))
			cellsToTry.append(Cell(cell.y+1,cell.x))
			cellsToTry.append(Cell(cell.y+1,cell.x+1))
		}
		
		cellsToTry = Array(Set(cellsToTry))
		
		cellsToTry.forEach { cell in
			let surrounding = getSurroundingCells(y: cell.y, x: cell.x, cells: cells)
			if !cells.contains(where: { $0.y == cell.y && $0.x == cell.x}) {
				//This is a blank cell
				if surrounding.count == 3 {
					newAliveCells.append(cell)
				}
			}
			else {
				if (2...3).contains(surrounding.count) {
					newAliveCells.append(cell)
				}
			}

		}
		return newAliveCells
	}
	
	func setCell(x: Int, y: Int, _ value: Int) {
		aliveCells.removeAll { yx in
			return yx.x == x && yx.y == y
		}
		if value == 1 {
			aliveCells.append(Cell(y,x))
		}
	}
	
	func process(_ iterations: Int = 1) {
		guard iterations > 0 else { return }
		var iterations = iterations
		while iterations > 0 {
			aliveCells = generate(aliveCells)
			iterations -= 1
			self.update = !self.update
		}
	}
}
