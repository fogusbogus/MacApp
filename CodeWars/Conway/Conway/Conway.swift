//
//  Conway.swift
//  Conway
//
//  Created by Matt Hogg on 29/09/2022.
//

import Foundation
import UsefulExtensions

public class Conway {
	public static func getSurroundingLiveCellCount(_ cells: [[Int]], x: Int, y: Int) -> Int {
		var ret = 0
		//print("in \(cells) at pos: [\(y),\(x)]")
		([y-1, 0].max()!..<[y+2,cells.count].min()!).forEach { yP in
			([x-1, 0].max()!..<[x+2, cells.first?.count ?? 0].min()!).forEach { xP in
				if !(yP == y && xP == x) {
					//print("[\(yP),\(xP)]")
					ret += cells[yP][xP]
				}
			}
		}
		return ret
	}
	
	public static func printCells(_ cells: [[Int]], blank: String = "0", filled: String = "1") {
		cells.forEach { line in
			let items : [String] = line.map { i in
				return i == 0 ? blank : filled
			}
			print(items.joined(separator: ""))
		}
	}
	
	public static func getGeneration(_ cells: [[Int]], generations: Int, callback: (([[Int]]) -> Void)? = nil) -> [[Int]] {
		let h = cells.count
		let w = cells.first!.count
		
		var ret : [[Int]] = []
		var line : [Int] = []
		(0...h).forEach { y in
			if y > 0 {
				ret.append(line)
				line = []
			}
			(0...w).forEach { x in
				let liveNeigbours = getSurroundingLiveCellCount(cells, x: x, y: y)
				if x == w || y == h || cells[y][x] == 0 {
					if liveNeigbours == 3 {
						line.append(1)
					}
					else {
						line.append(0)
					}
				}
				else {
					if liveNeigbours < 2 || liveNeigbours > 3 {
						line.append(0)
					}
					else {
						line.append(1)
					}
				}
			}
		}
		ret.append(line)
		//Let's see if we actually required the expansion
		if ret[ret.count - 1].filter({($0 == 1)}).count == 0 {
			ret.removeLast()
		}
		if ret.filter({$0.last! == 1}).count == 0 {
			let comp = ret.compactMap({ items in
				var i : [Int] = items
				i.removeLast()
				return i
			})
			ret = comp
		}
		if let c = callback {
			c(ret)
		}
		if generations < 2 {
			
			return ret
		}
		//print(ret)
		return getGeneration(ret, generations: generations - 1, callback: callback)
	}
}
