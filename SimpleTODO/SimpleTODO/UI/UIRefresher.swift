//
//  UIRefresher.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 24/07/2023.
//

import Foundation

class UIRefresher : ObservableObject {
	@Published var toggle: Bool = false
	
	func request() {
		toggle = !toggle
	}
}
