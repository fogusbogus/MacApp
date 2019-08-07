//
//  pnlButtons.swift
//  MacApp
//
//  Created by Matt Hogg on 06/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class pnlButtons: NSViewController {

	@IBAction func Save_Click(_ sender: NSButton) {
		handler?.save()
	}
	@IBAction func Cancel_Click(_ sender: NSButton) {
		handler?.cancel()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	
	public var handler: EditElectorButtonDelegate?
    
}

protocol EditElectorButtonDelegate {
	func save()
	func cancel()
}
