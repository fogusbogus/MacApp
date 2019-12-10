//
//  Numerical.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension Comparable {
	
	
	/// Keep a value in a certain range
	///
	/// - Parameters:
	///   - betweenThis: Lower range limit
	///   - andThis: Higher range limit
	/// - Returns: A value within the limits of betweenThis and andThis
	func clip(_ betweenThis: Self, _ andThis: Self) -> Self {
		
		//Let's be friendly and allow the lower and upper bounds to be passed in randomly
		let _min = betweenThis.min(andThis)
		let _max = andThis.max(betweenThis)
		if self < _min {
			return _min
		}
		if self > _max {
			return _max
		}
		return self
	}
	
	/// Keep a value in a certain range
	///
	/// - Parameter range: Limitation range
	/// - Returns: A value within the limits of the range
	func clip(_ range: NSRange) -> Self {
		return self.clip(range.lowerBound as! Self, range.upperBound as! Self)
	}
	
	
	/// Returns the minimum value in a range of values
	///
	/// - Parameter subsequent: A subset of values from which the minimum will be derived
	/// - Returns: The miniumum value
	func min(_ subsequent: Self...) -> Self {
		var ret = self
		for item in subsequent {
			if item < ret {
				ret = item
			}
		}
		return ret
	}
	
	/// Returns the maximum value in a range of values
	///
	/// - Parameter subsequent: A subset of values from which the maximum will be derived
	/// - Returns: The maximum value
	func max(_ subsequent: Self...) -> Self {
		var ret = self
		for item in subsequent {
			if item > ret {
				ret = item
			}
		}
		return ret
	}
	
	/// Multi-value comparison in one function. Usage: 0.quickSwitch(0, "Zero", 1, "One", 2, true, 3, 3.0)
	///
	/// - Parameters:
	///   - defaultValue: When a match is not found a default value must be used
	///   - compareAndResult: In pairs define the comparison and the result
	/// - Returns: The result or defaultValue
	func quickSwitch(defaultValue: Any? = nil, _ compareAndResult: Any?...) -> Any? {
		var dv: Any? = defaultValue
		
		for i in stride(from: 0, to: compareAndResult.count - 1, by: 2) {
			if let item = compareAndResult[i] {
				if item is Self {
					let selfItem = item as! Self
					if self == selfItem {
						return compareAndResult[i+1]
					}
				}
			}
			else {
				dv = compareAndResult[i+1]
			}
		}
		return dv
	}
	
	func `switch`<T>(_ defaultValue: T, _ parms: [Self:T]) -> T {
		let retItem = parms.first { (k, v) -> Bool in
			return k == self
		}
		if retItem == nil {
			return defaultValue
		}
		return retItem!.value
	}
	
	func match<T>(defaultValue: T, pairs: [Self:T]) -> T {
		if let candidateKey = pairs.keys.first(where: { (key) -> Bool in
			return key == self
		}) {
			return pairs[candidateKey]!
		}
		
		return defaultValue
	}
}
