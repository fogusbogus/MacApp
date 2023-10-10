//
//  Rect.swift
//  Physics
//
//  Created by Matt Hogg on 19/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class Rect : Comparable {
	public static func < (lhs: Rect, rhs: Rect) -> Bool {
		return lhs.Area < rhs.Area
	}
	
	public static func == (lhs: Rect, rhs: Rect) -> Bool {
		return lhs._x == rhs._x &&
			lhs._y == rhs._y &&
		lhs._w == rhs._w &&
		lhs._h == rhs._h
	}
	
	public var Area : Int {
		get {
			return (_w * _h) ^ 2
		}
	}
	
	private var _x = 0, _y = 0, _w = 0, _h = 0
	
	public var IsEmpty : Bool {
		get {
			return _x == 0 && _y == 0 && _w == 0 && _h == 0
		}
	}
	
	public func MakeEmpty() {
		_x = 0
		_y = 0
		_w = 0
		_h = 0
	}
	
	init() {
		
	}
	
	init(x: Int, y: Int, w: Int, h: Int) {
		_x = x
		_y = y
		_w = w
		_h = h
	}
	
	init(location: XY, w: Int, h: Int) {
		_x = location.x
		_y = location.y
		_w = w
		_h = h
	}
	
	public var Left : Int {
		get {
			return _x
		}
	}
	public var Top : Int {
		get {
			return _y
		}
	}
	public var Right : Int {
		get {
			return _x + _w
		}
	}
	public var Bottom : Int {
		get {
			return _y + _h
		}
	}
	
	public var X : Int {
		get {
			return _x
		}
		set {
			_x = newValue
		}
	}
	
	public var Y : Int {
		get {
			return _y
		}
		set {
			_y = newValue
		}
	}
	
	public var W : Int {
		get {
			return _w
		}
		set {
			if newValue >= 0 {
				_w = newValue
			}
		}
	}

	public var H : Int {
		get {
			return _h
		}
		set {
			if newValue >= 0 {
				_h = newValue
			}
		}
	}


	public func Inside(location: XY) -> Bool {
		return location.x >= Left && location.x <= Right && location.y >= Top &&
		location.y <= Bottom
	}
	
	public func Inside(x: Int, y: Int) -> Bool {
		return x >= Left && x <= Right && y >= Top && y <= Bottom
	}
}
