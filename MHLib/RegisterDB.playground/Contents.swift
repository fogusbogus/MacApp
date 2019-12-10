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
