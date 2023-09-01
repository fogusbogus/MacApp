//
//  VelocityHelper.swift
//  
//
//  Created by Matt Hogg on 08/10/2023.
//

import Foundation

class VelocityHelper {
	static func getVelocityValue(velocities: [String], index: Int = 0, direction: Direction = .down) -> Int {
		if let vel = Int(velocities[index]) {
			return vel
		}
	}
}

