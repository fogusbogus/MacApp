//
//  ShapeType.Enum.swift
//  TetrisClone
//
//  Created by Matt Hogg on 02/03/2021.
//

import Foundation

enum ShapeType {
	case L
	case Square
	case Line
	case ReverseL
	case Z
	case ReverseZ
	case T
	
	func shapePoints(rotation: RotationType) -> [(Int,Int)] {
		switch self {
			
			case .L:
				return rotation.rotatePoints(points: [(0,-1), (0,0), (0,1), (1,1)])
			case .Square:
				return rotation.rotatePoints(points: [(0,0), (0,1), (1,0), (1,1)])
			case .Line:
				return rotation.rotatePoints(points: [(0,-1), (0,0), (0,1), (0,2)])
			case .ReverseL:
				return rotation.rotatePoints(points: [(1,-1), (1,0), (1,1), (0,1)])
			case .Z:
				return rotation.rotatePoints(points: [(1,0), (0,1), (1,1), (0,2)])
			case .ReverseZ:
				return rotation.rotatePoints(points: [(0,0), (0,1), (1,1), (1,2)])
			case .T:
				return rotation.rotatePoints(points: [(0,-1), (0,0), (1,0), (0,1)])
		}
	}
}
