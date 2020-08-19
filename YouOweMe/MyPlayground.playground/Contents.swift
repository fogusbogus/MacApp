import Cocoa

typealias Real = NSDecimalNumber

func +(left: Real, right: Real) -> Real {
	return left.adding(right)
}
func -(left: Real, right: Real) -> Real {
	return left.subtracting(right)
}
func *(left: Real, right: Real) -> Real {
	return left.multiplying(by: right)
}
func /(left: Real, right: Real) -> Real {
	return left.dividing(by: right)
}
func ==(left: Real, right: Real) -> Bool {
	return left.compare(right) == ComparisonResult.orderedSame
}
func <(left: Real, right: Real) -> Bool {
	return left.compare(right) == ComparisonResult.orderedAscending
}
func <=(left: Real, right: Real) -> Bool {
	return left.compare(right) != ComparisonResult.orderedDescending
}
func >(left: Real, right: Real) -> Bool {
	return left.compare(right) == ComparisonResult.orderedDescending
}
func >=(left: Real, right: Real) -> Bool {
	return left.compare(right) != ComparisonResult.orderedAscending
}


var n1 = Real(value: 0)
var n2 = Real(value: 1)

print(n2 <= n1)
print(n1 + n2)
n1 = n2
n2 = n2 + n2
print(n1)
print(n2)

