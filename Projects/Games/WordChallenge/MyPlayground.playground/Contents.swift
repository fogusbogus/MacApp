import Cocoa

var a = [121, 144, 19, 161, 19, 144, 19, 11]
var b = [121, 14641, 20736, 361, 25921, 361, 20736, 361]

let c = a.filter { av in
	return b.first { bv in
		return bv % av == 0
	} != nil
}.count == a.count

print(c)
