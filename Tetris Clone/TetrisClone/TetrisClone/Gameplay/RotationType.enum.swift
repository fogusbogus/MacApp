//
//  RotationType.enum.swift
//  TetrisClone
//
//  Created by Matt Hogg on 02/03/2021.
//

import SwiftUI

enum RotationType : Int {
	case _0 = 0, _90 = 1, _180 = 2, _270 = 3
	
	func rotatePoints(points: [(Int,Int)]) -> [(Int,Int)] {
		var points = points
		var rep = self.rawValue
		while rep > 0 {
			rep -= 1
			let maxY0 = points.map { (pair) -> Int in
				let (_, y) = pair
				return y
			}.max() ?? 0
			let rot = points.map { (pair) -> (Int,Int) in
				let (x,y) = pair
				return (maxY0 - y,x)
			}
			
			points = rot
		}
		return points
	}
}
