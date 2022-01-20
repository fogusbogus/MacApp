import Cocoa
import Darwin

//Pascal's triangle

func getNextRow(_ row: [Int]) -> [Int] {
	var row = row
	row.insert(0, at: 0)
	row.append(0)
	return (0..<row.count-1).map{row[$0] + row[$0+1]}
}

if false
{
	var ar = [1]
	(0...50).forEach { _ in
		print(ar)
		ar = getNextRow(ar)
	}
	print(ar)
}

func index(_ x: Int, _ y: Int, _ w: Int) -> Int {
	return y * w + x
}

func getNextSpiralPositions(width: Int, height: Int) -> [Int] {
	var dx = width, dy = height, x = 0, y = 0
	var ret : [Int] = []
	let size = width * height
	while ret.count < size {
		ret.append(contentsOf: (x..<x+dx).map{index($0,y,width)})	//top
		y += 1
		dy -= 1
		ret.append(contentsOf: (y..<y+dy).map{index(x+dx,$0,width)})	//rhs
		ret.append(contentsOf: (x..<x+dx).reversed().map{index($0,y,width)})	//bottom
		dx -= 1
		ret.append(contentsOf: (y..<y+dy).reversed().map{index(x+dx,$0,width)})	//left
		x += 1
	}
	return ret
}

let legend = [[1,2,3], [8,9,4], [7,6,5]]
print(getNextSpiralPositions(width: 3, height: 3))

//Logically we should be getting 0,1,2,5,8,7,6,3,4
