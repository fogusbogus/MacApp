//
//  PropertyMap.swift
//  MacApp
//
//  Created by Matt Hogg on 24/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common
import MapKit
import CoreLocation			//Allows us to find the user location
import RegisterDB

class PropertyMapVC: NSViewController {

	//The delegate has been set on the storyboard
	@IBOutlet weak var mapView: MKMapView!
	override func viewDidLoad() {
        super.viewDidLoad()
		checkLocationServices()
        // Do view setup here.
    }
	@IBAction func onClick(_ sender: NSClickGestureRecognizer) {
		let loc = sender.location(in: mapView)
		print("\(loc.x),\(loc.y)")
	}
	
	private let _locMan = CLLocationManager()
	
	private func setupLocationManager() {
		_locMan.delegate = self
		_locMan.desiredAccuracy = kCLLocationAccuracyBest
	}
	
	/// Let's see if the user has allowed location services
	func checkLocationServices() {
		if CLLocationManager.locationServicesEnabled() {
			setupLocationManager()
			checkLocationAuthorisation()
		}
		else {
			//Show alert letting the user know they have to turn this on.
		}
	}
	
	func centreViewOnLocation(property: Property) {
		if property.GPS.contains(",") {
			let gps = property.GPS.keep("1234567890.,").split(separator: ",")
			if let lat = Double(gps[0]) {
				if let lon = Double(gps[1]) {
					let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
					let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
					mapView.setRegion(region, animated: true)
				}
			}
		}
	}
	
	func checkLocationAuthorisation() {
		switch CLLocationManager.authorizationStatus() {
		case .authorizedAlways:
			mapView.showsUserLocation = true
			break
			
		case .denied:
			//Show an alert instructing them how to turn on permissions
			break
			
		case .notDetermined:
			_locMan.requestLocation()
			break
			
		case .restricted:
			//Show an alert letting them know what's up
			break
		@unknown default:
			break
		}
	}
}

extension PropertyMapVC : CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		//
	}
	
	
}
