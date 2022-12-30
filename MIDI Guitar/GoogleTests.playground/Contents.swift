import Foundation

class LinkedList<T> {
	var value : T
	var next: LinkedList<T>?
	
	init(_ value: T, _ next: LinkedList<T>? = nil) {
		self.value = value
		self.next = next
	}
}

extension LinkedList {
	func reverse() -> LinkedList {
		var current : LinkedList? = self
		var prev : LinkedList? = nil
		var next : LinkedList? = nil
		while current != nil {
			next = current?.next
			current?.next = prev
			prev = current
			current = next
		}
		return prev!
	}
	
	func toArray() -> [T] {
		var ret : [T] = []
		var current : LinkedList? = self
		while current != nil {
			ret.append(current!.value)
			current = current?.next
		}
		return ret
	}
}


var a = LinkedList<Int>(5, LinkedList<Int>(4, LinkedList<Int>(3)))
print(a.toArray())
a = a.reverse()
print(a.toArray())
a = a.reverse()
print(a.toArray())
