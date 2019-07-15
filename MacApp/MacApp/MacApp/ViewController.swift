//
//  ViewController.swift
//  MacApp
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common

class ViewController: NSViewController, SelectedNodeListenerDelegate {
	func selectionChange(node: NodeBase?) {
		if node == nil {
			print("Nothing selected")
		}
		else {
			print("\(String(describing: node))")
		}
	}
	

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		_ = "Test".right(2)
		let child = self.children.filter { (vc) -> Bool in
			return vc is StreetVC
		} as? StreetVC
		child?.selectedNodeHandler = self
		
		print("")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

