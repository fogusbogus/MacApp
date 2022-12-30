import UIKit

class Collect<T> where T : Equatable {
	
	enum Errors : Error {
		case alreadyContainsValue(value: T)
		case valueDoesNotExist(value: T)
		case collectionIsEmpty
		case collectionCannotContainDuplicates
	}
	
	private var values: [T] = []
	
	init(_ presetValues: [T]? = nil) throws {
		if let presetValues = presetValues {
			
			//See if there are any duplicates!
			try presetValues.forEach { item in
				do {
					try add(item)
				}
				catch {
					throw Errors.collectionCannotContainDuplicates
				}
			}
			
			values = presetValues
		}
	}
	
	func add(_ newValue: T) throws {
		if values.contains(where: { item in
			return item == newValue
		}) {
			throw Errors.alreadyContainsValue(value: newValue)
		}
		values.append(newValue)
	}
	
	func remove(_ removeValue: T) throws {
		if !values.contains(where: { $0 == removeValue }) {
			throw Errors.valueDoesNotExist(value: removeValue)
		}
		values.removeAll { $0 == removeValue }
	}
	
	func getRandomValue() throws -> T {
		if values.count == 0 {
			throw Errors.collectionIsEmpty
		}
		return values[(0..<values.count).randomElement()!]
	}
	
	func getValues() -> [T] {
		return values
	}
}


var c = try Collect<Int>([5,2,4,20,50,5])

for _ in 0..<100 {
	print(try c.getRandomValue())
}

print (c.getValues())
