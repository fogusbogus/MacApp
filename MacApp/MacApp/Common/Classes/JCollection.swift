//
//  JCollection.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class JCollection {
	
	public func isDifferentFrom(other: JCollection) -> Bool {
		let c1 = other.toJsonString(sorted: true)
		let c2 = self.toJsonString(sorted: true)
		return c1.compare(c2) != .orderedSame
	}
	
	/// Gets an array of keys where differences occur in the values.
	///
	/// - Parameters:
	///   - other: The other collection to compare to
	///   - keysToIgnore: We may want to ignore some keys
	/// - Returns: An array of keys where the values differ
	public func compareTo(other: JCollection, keysToIgnore: [String]) -> [String] {
		return compareTo(other: other, comparison: { (value1, value2) -> Bool in
			return value1 != value2
		})
	}
	
	/// Gets an array of keys where differences occur in the values.
	///
	/// - Parameters:
	///   - other: The other collection to compare to
	///   - keysToIgnore: We may want to ignore some keys
	///   - comparison: Values are treated as String. Use this to compare. Return value true denotes a difference.
	/// - Returns: An array of keys where the values are compared as different.
	public func compareTo(other: JCollection, keysToIgnore: [String] = [], comparison: (String, String) throws -> Bool) -> [String] {
		var ret : [String] = []
		
		//See which keys are in one but not the other
		ret.append(contentsOf: self.keys.filter { (key) -> Bool in
			return !other.keys.contains(key)
		})
		//We need to repeat this for the other collection
		ret.append(contentsOf: other.keys.filter({ (key) -> Bool in
			return !self.keys.contains(key)
		}))
		
		//Now see if the values are different
		for _key in self.keys {
			if other.keys.contains(_key) {
				do {
					if try comparison(self.get(_key, ""), other.get(_key, "")) {
						ret.append(_key)
					}
				}
				catch {
					
				}
			}
		}
		
		//There may be some keys we don't want to know about
		ret.removeAll { (key) -> Bool in
			return keysToIgnore.contains(key)
		}
		
		//Return the keys uniquely as we may collect duplicates
		return ret.uniqueItems()
	}
	
	public func clear() {
		_dict.removeAll()
	}
	
	/// Quick string indexer
	///
	/// - Parameter key: Name of the Json object. Default is ""
	subscript(key: String) -> String {
		get {
			return get(key, "")
		}
		set {
			set(key, newValue)
		}
	}
	
	private var _dict = Dictionary<String, Any>()
	public func set(_ key : String, _ value: Any) {
		_dict[key] = value
	}
	
	public func setMany(keysAndValues kv: Any...) {
		for i in stride(from: 0, to: kv.count - 1, by: 2) {
			let k = "\(kv[i])"
			set(k, kv[i+1])
		}
	}
	
	public func setMany(pairArray: [String:Any]) {
		for (k, v) in pairArray {
			set(k, v)
		}
	}
	
	public func get<T>(_ key : String, _ defaultValue : T) -> T {
		let k = validKey(key)
		if !_dict.keys.contains(k) {
			return defaultValue
		}
		if let ret = _dict[k] as? T {
			return ret
		}
		if defaultValue is Int {
			let value = get(k, "")
			return Int(value) as! T
		}
		if defaultValue is Double {
			let value = get(k, "")
			return Double(value) as! T
		}
		return defaultValue
	}
	
	private func validKey(_ key: String) -> String {
		for k in _dict.keys {
			if k.implies(key) {
				return k
			}
		}
		return key
	}
	
	internal func getUntyped(_ key: String) -> Any {
		return _dict[key] ?? ""
	}
	
	internal var keys : Dictionary<String, Any>.Keys {
		get {
			return _dict.keys
		}
	}
	
	public init(json: String) {
		do {
			let parsedData = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as! [String:Any]
			
			for (key, item) in parsedData {
				_dict[key] = "\(item)"
			}
//			let stringData = parsedData as! [String:String]
//			for key in stringData.keys
//			{
//				_dict[key] = stringData[key]
//			}
		}
		catch {
			
		}
	}
	
	public func append(_ data: JCollection) {
		for key in data.keys {
			_dict[key] = data.getUntyped(key)
		}
	}
	
	public func toJsonString(sorted: Bool = false) -> String {
		if sorted {
			let dict = _dict.sorted { (first, second) -> Bool in
				return first.key < second.key
			}
			do {
				let jo = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
				return String(data: jo, encoding: .utf8) ?? ""
			}
			catch {
				return ""
			}
		}
		do {
			let jo = try JSONSerialization.data(withJSONObject: _dict, options: .prettyPrinted)
			return String(data: jo, encoding: .utf8) ?? ""
		}
		catch {
			return ""
		}
	}
}
