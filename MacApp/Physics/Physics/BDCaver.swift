//
//  BDCaver.swift
//  Physics
//
//  Created by Matt Hogg on 16/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class BDCaver : BDObject {
	
	public override init() {
		super.init()
	}
	override public init(x: Int, y: Int) {
		super.init(x: x, y: y)
	}
	override public init(location: XY) {
		super.init(location: location)
	}
	
	public final var IsDead : Bool = false
	
	public override var MovesIndependently: Bool {
		get {
			return false
		}
	}
	
	public override var CanMoveDirection: [MovementDirection] {
		get {
			return [.down, .left, .right, .up]
		}
	}
	
	public override var CanConsume: Bool {
		get {
			return false
		}
	}
}
