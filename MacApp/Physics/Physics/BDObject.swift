//
//  BDObject.swift
//  Physics
//
//  Created by Matt Hogg on 15/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class BDObject : Comparable, ObjectChangedLocationDelegate {
	public func LocationChanged(obj: BDObject?, x: Int, y: Int, ox: Int, oy: Int) {
		Map?.LocationChanged(obj: self, x: x, y: y, ox: ox, oy: oy)
	}
	
	public init() {
		
	}
	public init(location: XY) {
		self.Location.xy = location.xy
	}
	public init(x: Int, y: Int) {
		self.Location.x = x
		self.Location.y = y
	}
	
	public static func < (lhs: BDObject, rhs: BDObject) -> Bool {
		return lhs._id != rhs._id
	}
	
	public static func == (lhs: BDObject, rhs: BDObject) -> Bool {
		return lhs._id == rhs._id
	}
	
	internal var _id : Int = 0
	
	public final var Map : BDMap?
	
	public var MovesIndependently : Bool {
		get {
			return false
		}
	}
	public var FallInfluence : InfluenceType {
		get {
			return .none
		}
	}
	public var CanConsume : Bool {
		get {
			return true
		}
	}
	
	public var CanMoveDirection : [MovementDirection] {
		get {
			return [.none]
		}
	}
	private var _location : XY?
	
	public final var Location : XY {
		get {
			if _location == nil {
				_location = XY()
				_location?.Handler = self
			}
			return _location!
		}
	}
	
	public var AnimationRepeat : Int {
		get {
			return 0
		}
	}

	private var _animationIndex = 0
	
	public var AnimationIndex : Int {
		get {
			return _animationIndex
		}
		set {
			if AnimationRepeat != 0 {
				_animationIndex = newValue % AnimationRepeat
			}
			else {
				_animationIndex = 0
			}
		}
	}
	
	@discardableResult
	public func Animate() -> Int {
		if AnimationRepeat != 0 {
			_animationIndex = (_animationIndex + 1) % AnimationRepeat
		}
		return _animationIndex
	}
	
	public func Kill() {
		
	}
	
	public func CanBeKilledBy(obj: BDObject) -> Bool {
		return false
	}
	
	private var _fallToLeft = false
	
	public func Move() {
		if !MovesIndependently {
			return
		}
		
		let below = Map?.GetObject(obj: self, x: 0, y: 1)
		
		if below == nil {
			Location.Offset(x: 0, y: 1)
			return
		}
		
		if below!.FallInfluence == .none {
			//Cannot move
			return
		}
		
		_fallToLeft = !_fallToLeft
		
		let left = Map?.GetObject(obj: self, x: -1, y: 0)
		let right = Map?.GetObject(obj: self, x: 1, y: 0)
		for _ in 0..<2 {
			if below!.FallInfluence == .left || below!.FallInfluence == .either && !_fallToLeft {
				let empty = Map?.GetObject(obj: self, x: -1, y: 1)
				
				if empty == nil && left == nil {
					//Let's move
					Location.Offset(x: -1, y: 1)
					return
				}
			}
			if below!.FallInfluence == .right || below!.FallInfluence == .either && _fallToLeft {
				let empty = Map?.GetObject(obj: self, x: 1, y: 1)
				
				if empty == nil && right == nil {
					//Let's move
					Location.Offset(x: 1, y: 1)
					return
				}
			}
		}
	}
}

public enum InfluenceType {
	case none
	case left
	case right
	case either
}

public struct MovementDirection: OptionSet
{
	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}
    public let rawValue: UInt8

    static let none = MovementDirection(rawValue: 0x00)
    static let up = MovementDirection(rawValue: 0x01)
    static let down = MovementDirection(rawValue: 0x02)
    static let left = MovementDirection(rawValue: 0x04)
    static let right = MovementDirection(rawValue: 0x08)
}

public class XY : Comparable {
	
	public var Handler: ObjectChangedLocationDelegate?
	
	public static func < (lhs: XY, rhs: XY) -> Bool {
		return lhs.x < rhs.x || lhs.y < rhs.y
	}
	
	public static func == (lhs: XY, rhs: XY) -> Bool {
		return (!lhs.isSet && !rhs.isSet) || (lhs.x == rhs.x && lhs.y == rhs.y)
	}
	
	private var ox : Int?, oy : Int?
	
	public var x : Int {
		willSet {
			ox = x
		}
		didSet {
			_isSet = true
			if ox != nil && oy != nil {
				Handler?.LocationChanged(obj: nil, x: x, y: y, ox: ox!, oy: oy!)
			}
		}
	}
	
	public var y : Int {
		willSet {
			oy = y
		}
		didSet {
			_isSet = true
			if ox != nil && oy != nil {
				Handler?.LocationChanged(obj: nil, x: x, y: y, ox: ox!, oy: oy!)
			}
		}
	}
	
	public var xy : (Int, Int) {
		get {
			return (x, y)
		}
		set {
			let handler = Handler
			Handler = nil
			x = newValue.0
			y = newValue.1
			Handler = handler
			Handler?.LocationChanged(obj: nil, x: x, y: y, ox: ox!, oy: oy!)
		}
	}
	
	private var _isSet = false
	
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
	
	init() {
		x = 0
		y = 0
		_isSet = false
	}
	
	public func Offset(x: Int, y: Int) {
		let handler = Handler
		Handler = nil
		self.x += x
		self.y += y
		Handler = handler
		Handler?.LocationChanged(obj: nil, x: self.x, y: self.y, ox: ox!, oy: oy!)
	}
	
	public var isEmpty : Bool {
		get {
			return x == 0 && y == 0
		}
	}
	
	public var isSet : Bool {
		get {
			return _isSet
		}
	}
}
