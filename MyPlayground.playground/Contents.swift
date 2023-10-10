import UIKit

func find_missing(l:[Int]) -> Int {
	let sorted = l.sorted()
	let commonDistance = (sorted.last! - sorted.first!) / sorted.count
	let candidates = stride(from: sorted.first!, to: sorted.last!, by: commonDistance)
	return candidates.first(where: {!sorted.contains($0)}) ?? 0
}

print(find_missing(l: [12, 4, -4, -12, -20, -28, -44, -52, -60]))

print([2,4,6,8,10].reduce(0, {$1 - $0}))
print((10 - 2) / 4)
