//
//  BDMap.swift
//  Physics
//
//  Created by Matt Hogg on 15/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class BDMap : ObjectChangedLocationDelegate {
	public func LocationChanged(obj: BDObject?, x: Int, y: Int, ox: Int, oy: Int) {
		
		let oldKey = NumberKey(x: ox, y: oy)
		let newKey = NumberKey(x: x, y: y)
		if let _ = _quickMap[oldKey] {
			_quickMap.removeValue(forKey: oldKey)
		}
		_quickMap[newKey] = obj
		
		if x < _rect.X {
			_rect.X = x
		}
		if x > _rect.Right {
			_rect.W = x - _rect.X
		}
		if y < _rect.Y {
			_rect.Y = y
		}
		if y > _rect.Bottom {
			_rect.H = y - _rect.Y
		}
	}
	
	private func NumberKey(x: Int, y: Int) -> String {
		return String(format: "%08d%08d", x, y)
	}
	
	public init() {
		
	}
	
	private var _quickMap : [String:BDObject] = [:]
	
	/*
	TODO:
	
	quickMap is a quick way of getting an object from a set of coordinates (these make up
	the key). As we will be trapping the change of location, we can do that in here too.
	*/
	
	private var _id: Int = 0
	
	private var _objects : [BDObject] = []
	
	public func GetObject(obj: BDObject) -> BDObject? {
		return GetObject(obj: obj, x: 0, y: 0)
	}
	
	public func GetObject(obj: BDObject, x: Int, y: Int) -> BDObject? {
		let x = x + obj.Location.x
		let y = y + obj.Location.y
		return GetMapped(x: x, y: y) ?? _objects.first { (o : BDObject) -> Bool in
			return o.Location.x == x && o.Location.y == y
		}
	}
	
	private func GetMapped(x: Int, y: Int) -> BDObject? {
		return _quickMap[NumberKey(x: x, y: y)]
	}
	
	public func GetObjects(filter: (BDObject) -> Bool) -> [BDObject] {
		return _objects.filter { (obj: BDObject) -> Bool in
			return filter(obj)
		}
	}
	
	public func GetObjectsAtYPosition(y: Int) -> [BDObject] {
		return _objects.filter { (obj: BDObject) -> Bool in
			return obj.Location.y == y
		}
	}
	
	public func IsLocationTaken(location: XY) -> Bool {
		return (GetMapped(x: location.x, y: location.y) ?? GetObjectAtLocation(x: location.x, y: location.y)) != nil
	}
	public func IsLocationTaken(x: Int, y: Int) -> Bool {
		return GetObjectAtLocation(x: x, y: y) != nil
	}
	
	public func GetObjectAtLocation(x: Int, y: Int) -> BDObject? {
		return GetMapped(x: x, y: y) ?? _objects.first { (obj: BDObject) -> Bool in
			return obj.Location.x == x && obj.Location.y == y
		}
	}
	
	public func AddObject(obj: BDObject) {
		obj._id = _id
		if _objects.contains(where: { (o) -> Bool in
			return o == obj
		}) {
			return
		}
		_objects.append(obj)
		_id += 1
		obj.Map = self
	}
	
	private var _rect = Rect()
	
	public func GetBounds() -> Rect {
		return _rect
	}
	
	private func CalculateBounds() {
		if _objects.count == 0 {
			_rect.X = 0
			_rect.Y = 0
			_rect.W = 0
			_rect.H = 0
			return
		}
		
		let x = _objects.map {$0.Location.x}.min()!
		let y = _objects.map {$0.Location.y}.min()!
		let w = _objects.map {$0.Location.x}.max()! - x
		let h = _objects.map {$0.Location.y}.max()! - y

		_rect.X = x
		_rect.Y = y
		_rect.W	= w
		_rect.H = h
	}
	
	public func RemoveObject(obj: BDObject) {
		if !_objects.contains(obj) {
			return
		}
		_objects = _objects.filter({ (o) -> Bool in
			return o._id != obj._id
		})
	}
	
	public func Fall() {
		let toMove = _objects.filter { (obj: BDObject) -> Bool in
			return obj.MovesIndependently
		}
		
		toMove.forEach { (obj) in
			let loc = obj.Location
			obj.Move()
			if loc.x != obj.Location.x || loc.y != obj.Location.y {
				let caver = GetObjectAtLocation(x: obj.Location.x, y: obj.Location.y + 1) as? BDCaver
				if caver != nil {
					caver?.IsDead = true
				}
			}
		}
	}
	
	public func Animate() {
		Fall()
		_objects.forEach { (o) in
			o.Animate()
		}
	}
	
	public func MoveCaver(xOff: Int, yOff: Int) {
		let caver = _objects.first { (o) -> Bool in
			return o is BDCaver
		}
		if caver == nil {
			return
		}
		
		let inTheWay = GetObjectAtLocation(x: caver!.Location.x + xOff, y: caver!.Location.y + yOff)
		if inTheWay?.CanConsume ?? true {
			//This copes with null as well
			caver?.Location.Offset(x: xOff, y: yOff)
			if inTheWay != nil {
				_objects.removeAll { (o) -> Bool in
					return o._id == inTheWay!._id
				}
				return
			}
			
		}
		
		if let inTheWay = inTheWay {
			if inTheWay.CanMoveDirection != [.none] {
				let xsgn = xOff.signum()
				let ysgn = yOff.signum()
				
				if xsgn < 0 && !inTheWay.CanMoveDirection.contains(.left) {
					return
				}
				if xsgn > 0 && !inTheWay.CanMoveDirection.contains(.right) {
					return
				}
				if ysgn < 0 && !inTheWay.CanMoveDirection.contains(.up) {
					return
				}
				if ysgn > 0 && !inTheWay.CanMoveDirection.contains(.down) {
					return
				}
				
				let moveTo = GetObjectAtLocation(x: caver!.Location.x + xOff + xsgn, y: caver!.Location.y + yOff + ysgn)
				if moveTo == nil {
					inTheWay.Location.Offset(x: xOff, y: yOff)
					caver!.Location.Offset(x: xOff, y: yOff)
				}
			}
		}
	}
}

public protocol ObjectChangedLocationDelegate {
	func LocationChanged(obj: BDObject?, x: Int, y: Int, ox: Int, oy: Int)
}
