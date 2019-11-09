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
import DBLib
import Logging

class ViewController: NSViewController, SelectedNodeListenerDelegate, IIndentLog {
	var LogIndent: Int = 0
	
	private var _log : IIndentLog? = nil
	var Log : IIndentLog {
		get {
			return _log ?? self
		}
		set {
			_log = newValue
			LogFileURL = newValue.LogFileURL
		}
	}

	var DefaultFileName = "logFile.txt"
	private var _logFileURL : URL? = nil
	var LogFileURL : URL? {
		get {
			if _logFileURL == nil {
				let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
				_logFileURL = dir.appendingPathComponent(DefaultFileName)
				Log.Info("\n---------------------------------")
			}
			return _logFileURL
		}
		set {
			_logFileURL = newValue
		}
	}

	func IncreaseLogIndent() -> Int {
		return Log.ResetLogIndent(LogIndent + 1)
	}
	
	func DecreaseLogIndent() -> Int {
		return Log.ResetLogIndent(LogIndent - 1)
	}
	
	func ResetLogIndent(_ indent: Int) -> Int {
		LogIndent = indent < 0 ? 0 : indent
		return LogIndent
	}

	
	
	@IBOutlet weak var pnlStreets: NSView!
	
	var selectedNodeListener : SelectedNodeListenerDelegate?
	
	private var currentlySelectedNode: NodeBase?
	
	func selectionChange(node: NodeBase?) {

		Log.Label("Something new has been selected from the tree")
		Log.Checkpoint("selectionChange", { () -> Void in

			if node == nil {
				Log.Debug("Nothing selected")
			}
			else {
				Log.Debug("\(String(describing: node))")
			}
			currentlySelectedNode = node
			selectedNodeListener?.selectionChange(node: node)

		}, keyAndValues: ["node":node])
		
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		if let svc = segue.destinationController as? StreetVC {
			svc.selectedNodeHandler = selectedNodeListener ?? self
			svc.Log = self
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
		
		Log.Debug("Open the property window")
		Log.Checkpoint("openNewPropertyWindow()", {

			let wc = NSStoryboard(name: "NewProperty", bundle: nil)
			let np = wc.instantiateController(withIdentifier: "winController") as! NSWindowController
			np.showWindow(self)
			
		}, keyAndValues: [:])
		
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
		ret.MetaData.add(collection: ["fn":forenames[fn], "sn":surnames[sn], "dob":"1980-01-01" ])
		ret.save()
		return ret
	}
	
	func setupDB() {
		
		Log.Checkpoint("setupDB()", {
			
			Log.Debug("Create polling districts")
			let pd = PollingDistrict()
			pd.Name = "Cashes Green"
			pd.MetaData.add(collection: ["name":"Cashes Green", "ward":"Cainscross", "parliamentary":"Stroud"])
			pd.save()
			
			Log.Debug("Create streets")

			let st1 = pd.createStreet()
			st1.Name = "Berkeley Close"
			st1.GPS = ""
			st1.MetaData.add(collection: ["name":"Berkeley Close", "ward":"Cainscross", "parliamentary":"Stroud", "propCount":30])
			st1.save()
			for pn in 1...26 {
				let pr = newProp(street: st1, number: pn)
				for _ in 0...Int.random(in: 0...5) {
					newRandomElector(property: pr)
				}
			}
			
			let st2 = pd.createStreet()
			st2.Name = "Hunters Way"
			st1.MetaData.add(collection: ["name":"Hunters Way", "ward":"Cainscross", "parliamentary":"Stroud", "propCount":155])
			st2.save()
			for pn in 1...155 {
				let pr = newProp(street: st2, number: pn)
				for _ in 0...Int.random(in: 0...5) {
					newRandomElector(property: pr)
				}
			}
			Street.assertCounts()

		}, keyAndValues: [:])
		
	}

	override func viewDidLoad() {
		
		Log.Checkpoint("viewDidLoad", {
			
			super.viewDidLoad()
			
			setupDB()
			
			let m = DBLib.Meta()
			m.load(json: "{\"a\": {\"items\" : [{\"b\":\"0\", \"c\":\"1\"},{\"b\":\"1\", \"c\":\"2\"}]}}")
			
			// Do any additional setup after loading the view.
			_ = "Test".right(2)
			
			//		let find = pnlStreets.findView("StreetVC")
			//
			//		let child = pnlStreets.subviews.filter { (vc) -> Bool in
			//			return vc is StreetVC
			//		} as? StreetVC
			//child?.selectedNodeHandler = self
			
			print("")
		}, keyAndValues: [:])
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


