//
//  Extensions.swift
//  TreeViewDep
//
//  Created by Matt Hogg on 27/04/2023.
//

import Foundation

extension Array {
	
	func iterate(_ processor: (Element, Int) -> Void) {
		for i in 0..<count {
			processor(self[i], i)
		}
	}
}
