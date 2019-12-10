//
//  Protocols.swift
//  RegisterDB
//
//  Created by Matt Hogg on 09/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public protocol HasTODOItems {
	func getIDsForTODOItems(includeChildren: Bool) -> String
}

public protocol KeyedItem {
	var Key : String { get }
	
	var PDID : Int? { get set }
	var SID : Int? { get set }
	var PID : Int? { get set }
	var EID : Int? { get set }
}

public protocol LocatableItem {
	var GPS : String { get set }
	var Longitude : Double { get set }
	var Latitude : Double { get set }
}
