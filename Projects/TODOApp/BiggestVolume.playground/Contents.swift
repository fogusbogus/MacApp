import Cocoa

func calculateVolume(_ measurements: [Int], distance: Int? = nil) -> Int {
	guard measurements.count > 1 else { return 0 }
	
	let minSize = measurements.min()!
	let distance = distance ?? (measurements.count - 1)
	return minSize * distance
}

func calcMaxVolume(_ measurements: [Int]) -> (Int, Int, Int) {
	//Returning the start, end, volume
	guard measurements.count > 1 else { return (0,0,0) }
	
	var volumes : [Int:(Int,Int)] = [:]
	
	(0..<measurements.count).forEach { start in
		((start+1)..<measurements.count).forEach { end in
			volumes[calculateVolume([measurements[start], measurements[end]], distance: end - start)] = (start, end)
		}
	}
	print(volumes)
	if let result = volumes.sorted(by: { a, b in
		return a.key > b.key
	}).first {
		return (result.value.0, result.value.1, result.key)
	}
	return (0,0,0)
}

var measurements = [1,8,6,2,5,4,8,3,7]
let result = calcMaxVolume(measurements)
print("start: \(measurements[result.0]) [\(result.0)] -> end: \(measurements[result.1]) [\(result.1)] = \(result.2)")
