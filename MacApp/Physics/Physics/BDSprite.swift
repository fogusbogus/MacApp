//
//  BDSprite.swift
//  Physics
//
//  Created by Matt Hogg on 17/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class BDSprite : BDObject {
	
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
			return true
		}
	}
	
	public override func CanBeKilledBy(obj: BDObject) -> Bool {
		return obj is BDBoulder
	}
	
	private func IsOccupied(xOff: Int, yOff: Int) -> Bool {
		let obj = Map?.GetObjectAtLocation(x: Location.x + xOff, y: Location.y + yOff)
		return obj != nil && !(obj is BDSprite)
	}
	
	private func CalculateDirection() -> Int {
		var moveLeft = false, moveForward = false, moveRight = false
		
		switch _dir {
		case 0:
			moveLeft = IsOccupied(xOff: 1, yOff: 1) && !IsOccupied(xOff: 0, yOff: 1)
			moveForward = !IsOccupied(xOff: -1, yOff: 0)
			moveRight = !moveForward && IsOccupied(xOff: 0, yOff: 1)
			break
			
		case 1:
			moveLeft = IsOccupied(xOff: -1, yOff: 1) && !IsOccupied(xOff: -1, yOff: 0)
			moveForward = !IsOccupied(xOff: 0, yOff: -1)
			moveRight = !moveForward && IsOccupied(xOff: -1, yOff: 0)
			break
			
		case 2:
			moveLeft = IsOccupied(xOff: -1, yOff: -1) && !IsOccupied(xOff: 0, yOff: -1)
			moveForward = !IsOccupied(xOff: 1, yOff: 0)
			moveRight = !moveForward && IsOccupied(xOff: 0, yOff: -1)
			break
			
		case 3:
			moveLeft = IsOccupied(xOff: 1, yOff: -1) && !IsOccupied(xOff: 1, yOff: 0)
			moveForward = !IsOccupied(xOff: 0, yOff: 1)
			moveRight = !moveForward && IsOccupied(xOff: 1, yOff: 0)
			break

		default:
			return -1
		}
		
		if moveLeft {
			return (_dir + 3) % 4
		}
		if moveForward {
			return _dir
		}
		if moveRight {
			return (_dir + 1) % 4
		}
		return _dir
	}
	
	public override var FallInfluence: InfluenceType {
		get {
			return .either
		}
	}
	
	public override var CanMoveDirection: [MovementDirection] {
		get {
			return [.none]
		}
	}
	
	public override var CanConsume: Bool {
		get {
			return false
		}
	}
	
	public override var AnimationRepeat: Int {
		get {
			return 10;
		}
	}
	
	private var _dir = 0
	
	private func TryMove(dir: Int) -> Bool {
		var x = 0
		var y = 0
		switch dir {
		case 0:
			x = -1
			break
			
		case 1:
			y = -1
			break
			
		case 2:
			x = 1
			break
			
		case 3:
			y = 1
			break
			
		default:
			_dir = 0
			break
		}
		
		//Let's see if something is blocking me
		let blocking = Map?.GetObjectAtLocation(x: Location.x + x, y: Location.y + y)
		if blocking is BDCaver {
			//Need to kill them somehow
		}
		
		if blocking == nil {
			Location.Offset(x: x, y: y)
			return true
		}
		return false
	}
	
	public override func Kill() {
		if let map = Map {
			//Die Sprite, Die!
			map.RemoveObject(obj: self)
			let r = map.GetBounds()
			r.W -= 2
			r.H -= 2
			r.X += 1
			r.Y += 1
			
			for x in -1..<2 {
				for y in -1..<2 {
					let obj = map.GetObjectAtLocation(x: Location.x + x, y: Location.y + y)
					if !(obj is BDSprite) {
						obj?.Kill()
					}
					if !(obj is BDWall) && !(obj is BDCaver) {
						map.RemoveObject(obj: obj!)
					}
					
					let nx = Location.x + x
					let ny = Location.y + y
					if r.Inside(x: nx, y: ny) && obj != nil {
						let diamond = BDDiamond(x: Location.x + x, y: Location.y + y)
						diamond.Map = map
						diamond.AnimationIndex = -3
						map.AddObject(obj: diamond)
					}
				}
			}
		}
	}
	
	public override func Move() {
		_dir = CalculateDirection()
		if !TryMove(dir: _dir) {
			for i in 0..<3 {
				let idx = _dir + i
				if TryMove(dir: idx % 4) {
					_dir = idx
					return
				}
			}
		}
		else {
			_dir -= 1
		}
	}
}
