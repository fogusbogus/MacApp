//
//  AppDelegate.swift
//  Twinge.macOS
//
//  Created by Matt Hogg on 12/10/2020.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, LocalizationExtension, NSMenuDelegate {
	
	@objc dynamic var about = "About something"

	private var _mnuTitle = _resStr(file: "Application", cat: "Application", id: "Name")
	@objc dynamic var menuTitle : String {
		get {
			return "Twinge"
		}
	}
	

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

