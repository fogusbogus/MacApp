//
//  BDGrass.swift
//  Physics
//
//  Created by Matt Hogg on 17/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class BDGrass : BDObject {
	
	public override init() {
		super.init()
	}
	override public init(x: Int, y: Int) {
		super.init(x: x, y: y)
	}
	override public init(location: XY) {
		super.init(location: location)
	}
	public override var MovesIndependently: Bool {
		get {
			return false
		}
	}
	
	public override var FallInfluence: InfluenceType {
		get {
			return .none
		}
	}
	
	public override var CanMoveDirection: [MovementDirection] {
		get {
			return [.none]
		}
	}
	
	public override var CanConsume: Bool {
		get {
			return true
		}
	}
	
	public override func Move() {
	}
}
