//
//  Grid.swift
//  SudokuSolver
//
//  Created by Matt Hogg on 06/12/2020.
//

import Foundation

class Grid9x9 : Grid3x3Delegate {
	func ValuesInRow(row: Int) -> [Int] {
		<#code#>
	}
	
	func ValuesInColumn(col: Int) -> [Int] {
		<#code#>
	}
}


class Grid3x3 : CellDelegate {
	func ValuesInGrid3x3(cell: Cell) -> [Int] {
		return Cells.compactMap { (cell) -> Int? in
			return cell.Value
		}
	}
	
	func ValuesInRow(cell: Cell) -> [Int] {
		//We need to communicate with our delegate for this
		return delegate?.ValuesInRow(row: cell.y) ?? []
	}
	
	func ValuesInColumn(cell: Cell) -> [Int] {
		//We need to communicate with out delegate for this
		return delegate?.ValuesInColumn(col: cell.x) ?? []
	}
	
	var StartRow : Int
	var StartCol : Int
	
	var Cells : [Cell]
	
	var delegate : Grid3x3Delegate?
	
	init(startRow: Int, startCol: Int, delegate: Grid3x3Delegate?) {
		StartRow = startRow
		StartCol = startCol
		for row in 0..<3 {
			for col in 0..<3 {
				Cells.append(Cell(x: StartCol + col, y: StartRow + row, delegate: self))
			}
		}
		self.delegate = delegate
	}
}

protocol Grid3x3Delegate {
	func ValuesInRow(row: Int) -> [Int]
	func ValuesInColumn(col: Int) -> [Int]
}


class Cell {
	var x : Int
	var y : Int
	var Value : Int?
	var Candidates : [Int]
	
	var delegate : CellDelegate?
	
	func CalculateCandidates() {
		guard Value == nil else { return }
		
		var candidates : [Int] = [1,2,3,4,5,6,7,8,9]
		delegate?.ValuesInGrid3x3(cell: self).forEach({ (i) in
			candidates = candidates.filter({ (num) -> Bool in
				return num != i
			})
		})
		delegate?.ValuesInRow(cell: self).forEach({ (i) in
			candidates = candidates.filter({ (num) -> Bool in
				return num != i
			})
		})
		delegate?.ValuesInColumn(cell: self).forEach({ (i) in
			candidates = candidates.filter({ (num) -> Bool in
				return num != i
			})
		})
		if candidates.count == 1 {
			Value = candidates[0]
			Candidates = []
		}
		else {
			Candidates = candidates.sorted()
		}
	}
	
	init(x xValue: Int, y yValue: Int, delegate: CellDelegate?) {
		x = xValue
		y = yValue
		self.delegate = delegate
	}
}

protocol CellDelegate {
	func ValuesInGrid3x3(cell: Cell) -> [Int]
	func ValuesInRow(cell: Cell) -> [Int]
	func ValuesInColumn(cell: Cell) -> [Int]
}


/*
Elimination:

CommonCandidates:

In any of the collectors (row, column, 3x3), a common candidate is applicable if:

It occurs n times in a collector where n is also the number of candidates per cell and the candidates are all the same

*/
