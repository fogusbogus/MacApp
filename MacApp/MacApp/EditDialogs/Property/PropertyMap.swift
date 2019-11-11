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

class PropertyMapVC: NSViewControllerWithLog, MKMapViewDelegate {

	@IBOutlet weak var lblAddress: NSTextField!
	//The delegate has been set on the storyboard
	@IBOutlet weak var mapView: MKMapView!
	override func viewDidLoad() {
        super.viewDidLoad()
		checkLocationServices()
        // Do view setup here.
		
		mapView.mapType = .hybrid
		mapView.delegate = self
		
		_overlay = MKPinAnnotationView(frame: mapView.frame)
		
		let clickGR = NSClickGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		
		//let longPressRecognizer = NSPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		
		//longPressRecognizer.minimumPressDuration = 0.25
		mapView.addGestureRecognizer(clickGR)
		
		let coordinate = MKUserLocation().coordinate
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = "lat: \(coordinate.latitude), lng: \(coordinate.longitude)"
		//let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
		
		//mapView.addAnnotation(annotation)
		
		let london = MKPointAnnotation()
		london.title = "Londinium"
		london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
		//mapView.addAnnotation(london)
		
	
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKPointAnnotation {
			let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
			pin.pinTintColor = .purple
			pin.isDraggable = true
            pin.canShowCallout = true
            pin.animatesDrop = true
			
			return pin
		}
		return nil
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		if let an = view.annotation {
			print("\(an.subtitle)")
		}
	}
	
	private var _shiftPressed = false
	
	override func keyDown(with event: NSEvent) {
		var handler = false
		if event.modifierFlags.contains(.shift) {
			_shiftPressed = true
		}
		super.keyDown(with: event)
	}
	
	override func keyUp(with event: NSEvent) {
		if event.modifierFlags.contains(.shift) {
			_shiftPressed = false
		}
		super.keyUp(with: event)
	}
	
	@IBAction func onClick(_ sender: NSClickGestureRecognizer) {
		let loc = sender.location(in: mapView)
		print("\(loc.x),\(loc.y)")
	}
	
	private var _olay : MKOverlay?
	private var _overlay : MKPinAnnotationView?
	
	@objc
	func handleTap(_ gestureRecognizer: NSPressGestureRecognizer) {
		
//		if !_shiftPressed {
//			return
//		}
		let location = gestureRecognizer.location(in: mapView)
		let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
		
		//Add annotation to the view
		
		let annotation = mapPin(coordinates: coordinate, title: "lat: \(coordinate.latitude), lng: \(coordinate.longitude)", subTitle: "Somewhere")
		//annotation.coordinate = coordinate
		//annotation.title = "lat: \(coordinate.latitude), lng: \(coordinate.longitude)"
		
		lblAddress.stringValue = annotation.title!
		//let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
		
//		for an in mapView.annotations {
//			mapView.removeAnnotation(an)
//		}
		mapView.addAnnotation(annotation)
		mapView.showAnnotations(mapView.annotations, animated: false)
	}
	

	
	private var _selectedAnnotation : MKPointAnnotation?
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let an = view.annotation {
			let lat = "\(an.coordinate.latitude)"
			let lng = "\(an.coordinate.longitude)"
			print("lat: \(lat), lng: \(lng)")
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////

	private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
		let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
		mapView.setRegion(zoomRegion, animated: true)
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////

	
	
	private let _locMan = CLLocationManager()
	
	private func setupLocationManager() {
		Log.Checkpoint("Setting up the location manager", "setupLocationManager", {
			_locMan.delegate = self
			_locMan.desiredAccuracy = kCLLocationAccuracyBest
		}, keyAndValues: [:])
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

class mapPin : NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?

	init(coordinates : CLLocationCoordinate2D, title : String, subTitle : String = "") {
		self.coordinate = coordinates
		self.title = title
		self.subtitle = subTitle
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
