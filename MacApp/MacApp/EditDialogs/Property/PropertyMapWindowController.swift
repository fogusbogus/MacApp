//
//  PropertyMapWindowController.swift
//  MacApp
//
//  Created by Matt Hogg on 28/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class PropertyMapWindowController: ModalWindowController {
	
	func windowHasLoaded() {
		
	}
	
	class func loadFromNib() -> PropertyMapWindowController {
		
		let stb = NSStoryboard(name: "PropertyMap", bundle: nil)
		
		let vc = stb.instantiateController(withIdentifier: "PropertyMapWindowController") // as! PropertyMapWindowController
		
		return vc as! PropertyMapWindowController
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
	}
	
}
