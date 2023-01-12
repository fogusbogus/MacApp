//
//  main.swift
//  Kata
//
//  Created by Matt Hogg on 02/01/2023.
//

import Foundation
import SwiftUI

class LoopoverCanvas {
	init() {
		self.data = Loopover(grid: [
				["A", "B", "C", "D", "E"],
				["F", "G", "H", "I", "J"],
				["K", "L", "M", "N", "O"],
				["P", "Q", "R", "S", "T"],
				["U", "V", "W", "X", "Y"]
			])
	}
	
	
	var data: Loopover
	
	func render(context: inout GraphicsContext, size: CGSize) {
		let h = CGFloat(data.grid.count)
		let w = CGFloat(data.grid.first!.count)
		
		let cs = (size.width / w).min(size.height / h)
		
//		let mx = (size.width + w * cs) / 2
//		let my = (size.height + h * cs) / 2
		
		let ox = (size.width - w * cs) / 2
		let oy = (size.height - h * cs) / 2
		let data = data.grid
		var y = oy
		data.forEach { yData in
			var x = ox
			yData.forEach { c in

				context.draw(Text(c), in: CGRect(x: x, y: y, width: cs, height: cs))
				x += cs
			}
			y += cs
		}
	}
}

protocol MinMaxComparable : Comparable {
}

extension MinMaxComparable {
	func min(_ others: Self...) -> Self {
		let minOfOthers = others.min { $0 < $1 } ?? self
		return self < minOfOthers ? self : minOfOthers
	}
	func max(_ others: Self...) -> Self {
		let maxOfOthers = others.max { $0 < $1 } ?? self
		return self > maxOfOthers ? self : maxOfOthers
	}
}

extension CGFloat : MinMaxComparable {}
extension Double : MinMaxComparable {}

class Loopover {
	
	enum Move {
		case up, down, left, right
	}
	
	var grid: [[String]] = []
	
	init(grid: [[String]]) {
		self.grid = grid
		
		//Make sure the grid is even
		var w = -1
		grid.forEach { line in
			if w < 0 { w = line.count }
			if line.count != w {
				print("Error")
				return
			}
		}
		
		self.width = 0..<(grid.first?.count ?? 0)
		self.height = 0..<grid.count
	}
	
	private var width: Range<Int>, height: Range<Int>
	
	private func moveUp(col: Int) {
		guard width.contains(col) else { return }
		guard height.upperBound > 0 else { return }
		let carryOver = grid[height.first!][col]
		height.forEach { y in
			if height.contains(y+1) {
				grid[y][col] = grid[y+1][col]
			}
		}
		grid[height.last!][col] = carryOver
	}
	
	private func moveDown(col: Int) {
		guard width.contains(col) else { return }
		guard height.upperBound > 0 else { return }
		let carryOver = grid[height.last!][col]
		height.reversed().forEach { y in
			if height.contains(y-1) {
				grid[y][col] = grid[y-1][col]
			}
		}
		grid[height.first!][col] = carryOver
	}
	
	private func moveLeft(row: Int) {
		guard height.contains(row) else { return }
		guard width.upperBound > 0 else { return }
		let carryOver = grid[row][width.first!]
		width.forEach { x in
			if width.contains(x+1) {
				grid[row][x] = grid[row][x+1]
			}
		}
		grid[row][width.last!] = carryOver
	}
	
	private func moveRight(row: Int) {
		guard height.contains(row) else { return }
		guard width.upperBound > 0 else { return }
		let carryOver = grid[row][width.last!]
		width.reversed().forEach { x in
			if width.contains(x-1) {
				grid[row][x] = grid[row][x-1]
			}
		}
		grid[row][width.first!] = carryOver
	}
	
	func move(_ direction: Move, index: Int) {
		switch direction {
			case .up:
				moveUp(col: index)
			case .down:
				moveDown(col: index)
			case .left:
				moveLeft(row: index)
			case .right:
				moveRight(row: index)
		}
	}
	
	func getDisplay() -> [String] {
		return grid.map { $0.joined() }
	}
}


//var loop = Loopover(grid: [
//	["A", "B", "C", "D", "E"],
//	["F", "G", "H", "I", "J"],
//	["K", "L", "M", "N", "O"],
//	["P", "Q", "R", "S", "T"],
//	["U", "V", "W", "X", "Y"]
//])
//
//print(loop.getDisplay())
//
//loop.move(.up, index: 3)
//
//print(loop.getDisplay())
//
//
//let l = 0...5
//print(l.last!)
