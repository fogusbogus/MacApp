import Cocoa

protocol A {
	func DefinedInA()
}

class FromA : A {
	final func DefinedInA() {
		
	}
}

class FromFromA : FromA {
	
}

let c = FromFromA()
c.DefinedInA()
var str = "Hello, playground"


var a = 0...360

a.map {sin(Double($0)) }
a.map {cos(Double($0))}


print (a.reduce(1) { (i, v) -> Int in
	return i + v
})
