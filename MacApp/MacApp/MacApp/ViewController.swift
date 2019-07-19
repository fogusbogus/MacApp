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
	
	@IBOutlet weak var pnlStreets: NSView!
	
	var selectedNodeListener : SelectedNodeListenerDelegate?
	
	private var currentlySelectedNode: NodeBase?
	
	func selectionChange(node: NodeBase?) {
		if node == nil {
			print("Nothing selected")
		}
		else {
			print("\(String(describing: node))")
		}
		currentlySelectedNode = node
		selectedNodeListener?.selectionChange(node: node)
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		if let svc = segue.destinationController as? StreetVC {
			svc.selectedNodeHandler = selectedNodeListener ?? self
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		_ = "Test".right(2)
		
		let find = pnlStreets.findView("StreetVC")
		
		let child = pnlStreets.subviews.filter { (vc) -> Bool in
			return vc is StreetVC
		} as? StreetVC
		//child?.selectedNodeHandler = self
		
		print("")
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}

extension NSView {
	
	func findView(_ typeName: String, _ findParent: Bool = true) -> NSView? {
		var ref = self
		if findParent {
			while let parent = ref.superview {
				ref = parent
			}
		}
		for child in ref.subviews {
			print("\(child.className)")
			if child.className.implies(typeName) {
				return child
			}
			if let ret = child.findView(typeName, false) {
				return ret
			}
		}
		return nil
	}
	
}
