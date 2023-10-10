//
//  PainPoint.swift
//  AnginaSwiftUI
//
//  Created by Matt Hogg on 31/12/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation
import UIKit

class PainPoint {
	init(Name: String, x: Double, y: Double, delegate: PainPointDelegate? = nil) {
		self.Name = Name
		self.x = x
		self.y = y
		self.delegate = delegate
	}
	
	var Name : String = ""
	var x : Double = 0, y : Double = 0
	var size : Int = 48
	var pain : Int = 0 {
		didSet {
			delegate?.painChanged(painPoint: self)
		}
	}
	
	var delegate : PainPointDelegate?
	
	func inRelationTo(size: CGSize) -> CGPoint {
		return CGPoint(x: Double(size.width) * x, y: Double(size.width) * y)
	}
}

protocol PainPointDelegate {
	func painChanged(painPoint: PainPoint)
}
