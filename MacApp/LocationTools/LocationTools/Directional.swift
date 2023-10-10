//
//  Directional.swift
//  LocationTools
//
//  Created by Matt Hogg on 25/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import MapKit

public class Directional {
	
	public static func getBearing(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double {
		return getBearing(lat1: origin.latitude, lng1: origin.longitude, lat2: destination.latitude, lng2: destination.longitude)
	}
	
	public static func getBearing(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
		let y = sin(lat2 - lat1) * cos(lng2)
		let x = cos(lng1) * sin(lng2) - sin(lng1) * cos(lng2) * cos(lat2 - lat1)
		return toDegrees(radians: atan2(y, x))
	}
	
	public static func getDistance(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double {
		return getDistance(lat1: origin.latitude, lng1: origin.longitude, lat2: destination.latitude, lng2: destination.longitude)
	}
	
	public static func getDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
		let R = 6371.0
		let theta1 = toRadians(angle: lat1)
		let theta2 = toRadians(angle: lat2)
		let deltaThetaHalf = toRadians(angle: lat2 - lat1) / 2.0
		let deltaLamdaHalf = toRadians(angle: lng2 - lng1) / 2.0
		
		let a = sin(deltaThetaHalf) * sin(deltaThetaHalf) + cos(theta1) * cos(theta2) * sin(deltaLamdaHalf) * sin(deltaLamdaHalf)
		let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
		return R * c
	}
	
	public static func toRadians(angle: Double) -> Double {
		return angle * Double.pi / 180.0
	}
	
	public static func toDegrees(radians: Double) -> Double {
		return radians * 180.0 / Double.pi
	}
}
