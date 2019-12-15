//
//  Protocols.swift
//  RegisterDB
//
//  Created by Matt Hogg on 09/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import DBLib
import MapKit

public protocol HasTODOItems {
	func getIDsForTODOItems(includeChildren: Bool, includeComplete: Bool) -> String
	static func getIDsForTODOItems(db: SQLDBInstance, id: Int, includeChildren: Bool, includeComplete: Bool) -> String
}

public protocol Iconised {
	static func calculateIcon(db: SQLDBInstance, id: Int) -> String
}

public protocol KeyedItem {
	var Key : String { get }
	
	var PDID : Int? { get set }
	var SID : Int? { get set }
	var PID : Int? { get set }
	var EID : Int? { get set }
	
	static func getChildrenIDs(db: SQLDBInstance, id: Int) -> [Int]
	static func getCalculatedName(db: SQLDBInstance, id: Int) -> String
}

public protocol LocatableItem {
	var GPS : String { get set }
	var Longitude : Double { get set }
	var Latitude : Double { get set }
	
	func getCoord() -> CLLocationCoordinate2D
}
