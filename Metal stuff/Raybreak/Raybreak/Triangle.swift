//
//  Triangle.swift
//  Raybreak
//
//  Created by Matt Hogg on 18/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation
import MetalKit

class Triangle {
	var vertices: [Float] = [
	0,0,0, 0,0,0, 0,0,0]
	
	var color: MTLClearColor
	
	init(_ vertices: [Float], color: MTLClearColor) {
		self.vertices = vertices
		self.color = color
	}
}
