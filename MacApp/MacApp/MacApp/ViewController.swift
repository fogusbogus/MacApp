//
//  ViewController.swift
//  MacApp
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Common
import RegisterDB

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
	
	@discardableResult
	func newProp(street: Street, number: Int) -> Property {
		let p = street.createProperty()
		p.Number = number
		p.save()
		return p
	}
	
	func openNewPropertyWindow() {
		let wc = NSStoryboard(name: "NewProperty", bundle: nil)
		let np = wc.instantiateController(withIdentifier: "winController") as! NSWindowController
		np.showWindow(self)
	}
	
	@discardableResult
	func newRandomElector(property: Property) -> Elector {
		let surnames = ["Andrews", "Brown", "Cox", "Delamare", "Edgebaston", "Frederiksen", "Gamble", "Hopps", "Ing", "Johnson", "Kilmarnock", "Lewis", "Mann", "Nero", "Ogilvie", "Petersen", "Roberts", "Stevens", "Thomas", "Vick", "Williams", "Yanush"]
		
		let forenames = ["Adrian", "Annette", "Barry", "Belinda", "Carl", "Charlotte", "David", "Delilah", "Earl", "Elizabeth", "Frank", "Francis", "Gerald", "Georgina", "Harold", "Helen", "Isaac", "Isabelle", "John", "Julie", "Kevin", "Karen", "Liam", "Lorna", "Michael", "Mary", "Nigel", "Nina", "Oswald", "Ola", "Peter", "Penny", "Quentin", "Roger", "Rene", "Todd", "Tessa", "Uri", "Victor", "Vicky", "Will", "Wanda", "Yolanda", "Ziggy", "Zoe"]
		
		let sn = Int.random(in: 0..<surnames.count)
		let fn = Int.random(in: 0..<forenames.count)
		let ret = property.createElector()
		ret.Forename = forenames[fn]
		ret.Surname = surnames[sn]
		ret.DisplayName = "\(ret.Forename) \(ret.Surname)"
		ret.save()
		return ret
	}
	
	func setupDB() {
		
		let pd = PollingDistrict()
		pd.Name = "Cashes Green"
		pd.save()
		
		let st1 = pd.createStreet()
		st1.Name = "Berkeley Close"
		st1.GPS = ""
		st1.save()
		for pn in 1...26 {
			let pr = newProp(street: st1, number: pn)
			for _ in 0...Int.random(in: 0...5) {
				newRandomElector(property: pr)
			}
		}
		
		let st2 = pd.createStreet()
		st2.Name = "Hunter's Way"
		st2.save()
		for pn in 1...155 {
			let pr = newProp(street: st2, number: pn)
			for _ in 0...Int.random(in: 0...5) {
				newRandomElector(property: pr)
			}
		}
		Street.assertCounts()
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupDB()

		// Do any additional setup after loading the view.
		_ = "Test".right(2)
		
//		let find = pnlStreets.findView("StreetVC")
//
//		let child = pnlStreets.subviews.filter { (vc) -> Bool in
//			return vc is StreetVC
//		} as? StreetVC
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


