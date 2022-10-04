import Foundation

public class Conway {
	public static func getSurroundingLiveCellCount(_ cells: [[Int]], x: Int, y: Int) -> Int {
		var ret = 0
		([y-1, 0].max()!..<[y+2,cells.count].min()!).forEach { yP in
			([x-1, 0].max()!..<[x+2, cells.first?.count ?? 0].min()!).forEach { xP in
				if yP != y && xP != x && cells[yP][xP] == 1 {
					ret += 1
				}
			}
		}
		return ret
	}
	
	public static func getGeneration(_ cells: [[Int]], generations: Int) -> [[Int]] {
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
		if generations < 1 {
			return ret
		}
		print(ret)
		return getGeneration(ret, generations: generations - 1)
	}
}
