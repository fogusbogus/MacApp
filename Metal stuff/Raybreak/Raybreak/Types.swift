//
//  Types.swift
//  Raybreak
//
//  Created by Matt Hogg on 19/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation
import simd

struct Vertex {
	var position: SIMD3<Float>
	var color: SIMD4<Float>
	var texture: SIMD2<Float>
}
