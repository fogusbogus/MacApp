//
//  main.swift
//  JsonPlayground
//
//  Created by Matt Hogg on 20/12/2022.
//

import Foundation

print("Hello, World!")

protocol SomeType{
	
}

struct Parent : Codable {
	public var types: [SomeType]
}

struct TypeA : SomeType, Codable {
	var name: String
	var value: Int
}

struct TypeB: SomeType, Codable {
	var desc: String
	var val : Double
}
