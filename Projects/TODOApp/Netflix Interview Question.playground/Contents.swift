import Cocoa

//1,3, 2,6, 8,10, 15,18

func mergeIntervals(intervals: [[Int]]) -> [[Int]] {
	guard intervals.count > 1 else { return intervals }
	
	//Let's rebuild this array of pairs!
	var result : [[Int]] = []
	intervals.forEach { intPair in
		
		print("Merging pair \(intPair)")
		
		//We are assuming these are a start and an end - and not the other way around!
		let start = intPair[0]
		let end = intPair[1]
		
		//Is this consumed?
		if let r = result.first(where: { subIntPair in
			let resStart = subIntPair[0]
			let resEnd = subIntPair[1]
			return resStart <= start && resEnd >= end
		}) {
			print("\(intPair) is already covered by \(r)")
			return
		}
		
		//Remove any from the results that this new one consumes in whole
		result.removeAll { subIntPair in
			let resStart = subIntPair[0]
			let resEnd = subIntPair[1]
			if start < resStart && end > resEnd {
				print("\(intPair) will consume \(subIntPair) which will be removed")
			}
			return start < resStart && end > resEnd
		}
		
		//Find those where the start is less
		if let alterIndex = result.firstIndex(where: { subIntPair in
			return start < subIntPair[0] && end <= subIntPair[1] && end >= subIntPair[0]
		}) {
			print("\(result[alterIndex]) -> [\(start), \(result[alterIndex][1])]")
			result[alterIndex][0] = start
		}
		else {
			if let alterIndex = result.firstIndex(where: { subIntPair in
				return start >= subIntPair[0] && end >= subIntPair[1] && start <= subIntPair[1]
			}) {
				print("\(result[alterIndex]) -> [\(result[alterIndex][0]), \(end)]")
				result[alterIndex][1] = end
			}
			else {
				result.append(intPair)
				print("\(intPair) has been added")
			}
		}
	}
	return result
}


print(mergeIntervals(intervals: [[1,3], [0,6], [8,10], [15,18], [15,18], [500, 1999], [498, 600]]))
