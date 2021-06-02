//
//  Tetromino.swift
//  TetrisClone
//
//  Created by Matt Hogg on 02/03/2021.
//

import SwiftUI

class Tetromino {
	var type: ShapeType
	var color: Color
	var rotation: RotationType
	var x: Int, y: Int
	
	init(x xpos: Int) {
		//Do something random
		rotation = RotationType(rawValue: Int.random(in: 0...3))!
		color = Color(UIColor.systemBackground)
		switch Int.random(in: 0...4) {
			case 0:
				color = .blue
			case 1:
				color = .red
			case 2:
				color = .green
			case 3:
				color = .yellow
			default:
				color = .orange
		}
		y = 1
		x = xpos
		
		//The shape itself
		switch Int.random(in: 0...6) {
			case 0:
				type = .L
			case 1:
				type = .Line
			case 2:
				type = .Z
			case 3:
				type = .ReverseZ
			case 4:
				type = .ReverseL
			case 5:
				type = .Square
			case 6:
				type = .T
			default:
				type = .T
		}
	}
}
