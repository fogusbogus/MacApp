//
//  Date.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public extension Date {
	func toISOString() -> String {
		return ISO8601DateFormatter().string(from: self)
	}
}
