//
//  ObjectRepository.swift
//  RegisterDB
//
//  Created by Matt Hogg on 03/02/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//

import Foundation
import UsefulExtensions

public class ObjectRepository {
	private var _items : [String:Any?] = [:]
	
	/// Get a repository item or initialise if missing
	/// - Parameters:
	///   - key: Caseless name of the item
	///   - initial: This is called and the return value stored against the key
	public func get<T>(_ key: String, initial: () -> T) -> T {
		let rk = realKey(key)
		if !_items.keys.contains(rk) {
			_items[rk] = initial()
		}
		return _items[rk] as! T
	}
	
	/// Get a repository item or with a default value if missing
	/// - Parameters:
	///   - key: Caseless name of the item
	///   - defaultValue: This is the default value if the item is missing
	public func get<T>(_ key: String, defaultValue: T) -> T {
		let rk = realKey(key)
		if !_items.keys.contains(rk) {
			return defaultValue
		}
		return _items[rk] as! T
	}
	
	/// Remove an item from the collection
	/// - Parameter key: Caseless name of the item
	public func remove(_ key: String) {
		let rk = realKey(key)
		_items.removeValue(forKey: rk)
	}
	
	/// Returns the case key for a given caseless key
	/// - Parameter key: Caseless key
	private func realKey(_ key: String) -> String {
		//It's either one of the keys or a new one
		return _items.keys.first { (s) -> Bool in
			return s.implies(key)
		} ?? key
	}
}
