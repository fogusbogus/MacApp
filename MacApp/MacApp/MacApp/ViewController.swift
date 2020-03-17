//
//  ViewController.swift
//  MacApp
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import UsefulExtensions
import RegisterDB
import SQLDB
import LoggingLib

class ViewController: NSViewController, SelectedNodeListenerDelegate, IIndentLog, SubviewHandler, TableSelectionHasChangedDelegate {
	func selectedRowChanged(_ owner: Any, _ row: Int, jsonData: String?) {
		print("row selected: \(row), \(String(describing: jsonData))")
		if jsonData!.length() > 0 {
			let data = JCollection(json: jsonData!)
			vcElecs?.loadFromProperty(db: Databases.shared.Register, propertyID: data.get("pid", -1))
			selectFromKey(linkType: .property, id: data.get("id", -1), parentID: data.get("sid", -1))
		}
	}
	
	
	func notifySubview(view: Any) {
		if let view = view as? vcProperties {
			vcProps = view
			vcProps?.RowChangedHandler = self
		}
		if let view = view as? vcElectors {
			vcElecs = view
		}
	}
	
	private var vcProps : vcProperties?
	private var vcElecs : vcElectors?
	
	var IndentLog_Indent: Int = 0
	
	private var _log : IIndentLog? = nil
	var IndentLog_Instance : IIndentLog? {
		get {
			return _log ?? self
		}
		set {
			_log = newValue
			if newValue != nil {
				IndentLog_URL = newValue!.IndentLog_URL
			}
		}
	}
	
	func selectFromKey(linkType: LinkType, id: Int, parentID: Int) {
		_streetVC?.selectNode(linkType: linkType, id: id)
		if linkType == .street {
			return
		}
		if linkType == .property {
			_streetVC?.expandNode(linkType: .street, id: parentID)
			vcProps?.select(id: id)
			return
		}
		if linkType == .elector {
			_streetVC?.expandNode(linkType: .property, id: parentID)
			vcElecs?.select(id: id)
		}
	}

	var DefaultFileName = "logFile.txt"
	private var _logFileURL : URL? = nil
	var IndentLog_URL : URL? {
		get {
			if _logFileURL == nil {
				let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
				_logFileURL = dir.appendingPathComponent(DefaultFileName)
				Log.info("\n---------------------------------")
			}
			return _logFileURL
		}
		set {
			_logFileURL = newValue
		}
	}
	
	func testArea() {
		do {
			let h = URL.init(string: "http://192.168.1.254/00000110500/gui/#/basicStatus")
			let html = try String(contentsOf: h!)
			print(html)
		}
		catch {}
	}
	
	var Log : IIndentLog? {
		get {
			return IndentLog_Instance
		}
		set {
			IndentLog_Instance = newValue
		}
	}

//	func IncreaseLogIndent() -> Int {
//		return Log?.ResetLogIndent(LogIndent + 1) ?? 0
//	}
//
//	func DecreaseLogIndent() -> Int {
//		return Log?.ResetLogIndent(LogIndent - 1) ?? 0
//	}
//
//	func ResetLogIndent(_ indent: Int) -> Int {
//		LogIndent = indent < 0 ? 0 : indent
//		return LogIndent
//	}

	@IBOutlet weak var vwPropElecs: NSView!
	
	public var pnlPropElecs : vcPropElecs {
		get {
			
			return vwPropElecs as! vcPropElecs
		}
	}
	
	private weak var _streetVC : StreetVC?
	
	@IBOutlet weak var pnlStreets: NSView!
	
	@IBOutlet weak var pnlPE: NSView!
	
	var selectedNodeListener : SelectedNodeListenerDelegate?
	
	private var _currentlySelectedNode: NodeBase?
	
	private var currentlySelectedNode: NodeBase? {
		get {
			return _currentlySelectedNode
		}
		set {
			_currentlySelectedNode = newValue
			if let street = newValue?.linkedItem as? Street {
				vcProps?.loadFromStreet(db: street.SQLDB, streetID: street.ID!)
			}
		}
	}
	
	func selectionChange(node: NodeBase?) {
		
		let subv = pnlPE.allSubviews().first { (sv) -> Bool in
			return sv is NSTableView
		}
		
		Log.checkpoint("Something new has been selected from the tree", "selectionChange", { () -> Void in

			if node == nil {
				Log.debug("Nothing selected")
			}
			else {
				Log.debug("\(String(describing: node))")
			}
			currentlySelectedNode = node
			selectedNodeListener?.selectionChange(node: node)

		}, keyAndValues: ["node":node])
		
	}
	
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		
		//Log.Checkpoint("Segue preparation", "prepare", {
		if let svc = segue.destinationController as? SubviewNotifier {
			svc.subscribe(self)
		}
		if let svc = segue.destinationController as? StreetVC {
			_streetVC = svc
			Log.debug("Segue is StreetVC")
			svc.selectedNodeHandler = selectedNodeListener ?? self
			svc.Log = self
		}
		if let svc = segue.destinationController as? vcPropElecs {
			Log.debug("Segue is vcPropElecs")
		}
		//}, keyAndValues: ["segue":segue, "sender":sender])
	}
	
	@discardableResult
	func newProp(street: Street, number: Int) -> Property {
		
		//return Log.Checkpoint("New property", "newProp", { () -> Property in
		let p = street.createProperty()
		p.Number = number
		p.save()
		return p
		//}, keyAndValues: ["street":street, "number":number])
	}
	
	func openNewPropertyWindow() {
		
		Log.checkpoint("Open the property window", "openNewPropertyWindow()", {

			let wc = NSStoryboard(name: "NewProperty", bundle: nil)
			let np = wc.instantiateController(withIdentifier: "winController") as! NSWindowController
			np.showWindow(self)
			
		}, keyAndValues: [:])
		
	}
	
	private var _forenames : [(String,String)] = []
	@discardableResult
	private func getForenames() -> [(String,String)] {
		if _forenames.count == 0 {
			testArea()
			let db = SQLDBInstance()
			db.open(path: "names.sqlite", openCurrent: true)

			var ret : [(String,String)] = []
			db.processMultiRow(rowHandler: { (row) in
				//print(row.get("name", ""))
				ret.append((row.get("name", ""), row.get("sex", "")))
			}, "SELECT * FROM Names ORDER BY 1")

			//let rows = Databases.shared.Names.queryMultiRow("SELECT * FROM Names")
			
			
			//for row in rows {
			//	ret.append((row.get("Name", ""), row.get("sex", "")))
			//}
			_forenames = ret
		}
		return _forenames
	}
	
	@discardableResult
	func newRandomElector(property: Property) -> Elector {
		let surnames = ["Andrews", "Brown", "Cox", "Delamare", "Edgebaston", "Frederiksen", "Gamble", "Hopps", "Ing", "Johnson", "Kilmarnock", "Lewis", "Mann", "Nero", "Ogilvie", "Petersen", "Roberts", "Stevens", "Thomas", "Vick", "Williams", "Yanush"]
		
		let forenames = getForenames()
		
		let sn = Int.random(in: 0..<surnames.count)
		let fn = Int.random(in: 0..<forenames.count)
		let ret = property.createElector()
		ret.Forename = forenames[fn].0
//		if forenames[fn].1.implies("M") {
//			ret.MetaData.Gender = "Male"
//		}
//		else {
//			ret.MetaData.Gender = "Female"
//		}
		ret.Surname = surnames[sn]
		ret.DisplayName = "\(ret.Forename) \(ret.Surname)"
		let gender = forenames[fn].1 == "M" ? "Male" : "Female"
		
		ret.MetaData.add(collection: ["fn":ret.Forename, "sn":surnames[sn], "dob":"1980-01-01", "gender":gender ])
		ret.save()
		return ret
	}
	
	func setupDB() {
		
		Log.checkpoint("Setting up the database with random fluff", "setupDB()", {
			
			getForenames()
			
			Log.debug("Create polling districts")
			let pd = PollingDistrict(db: Databases.shared.Register)
			pd.Name = "Cashes Green"
			pd.MetaData.add(collection: ["name":"Cashes Green", "ward":"Cainscross", "parliamentary":"Stroud"])
			pd.save()
			
			Log.debug("Create streets")

			let st1 = pd.createStreet()
			st1.Name = "Berkeley Close"
			st1.GPS = ""
			st1.MetaData.add(collection: ["name":"Berkeley Close", "ward":"Cainscross", "parliamentary":"Stroud", "propCount":30])
			st1.save()
			
			Log.debug("Create 26 properties in 'Berkeley Close' and a random amount of electors in each one")
			for pn in 1...26 {
				let pr = newProp(street: st1, number: pn)
				for _ in 0...Int.random(in: 0...5) {
					newRandomElector(property: pr)
				}
			}
			pd.recalculateCounts()
			st1.recalculateCounts()
			//Log.debug("\(st1.ElectorCount) electors created")

			Log.debug("Create 155 properties in 'Hunter's Way' and a random amount of electors in each one")
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
			st2.recalculateCounts()
			PollingDistrict.assertCounts(db: Databases.shared.Register)
			
			let streets = pd.GetStreets()
			for street in streets {
				Log.args("Street: \(street.Name)", ["Properties":street.PropertyCount, "Electors":street.ElectorCount])
			}
			
			let totalElectors = st1.ElectorCount + st2.ElectorCount
			Log.debug("\(totalElectors) electors created")
			//Log.debug("\(st2.ElectorCount) electors created")

		}, keyAndValues: [:])
		
	}

	override func viewDidLoad() {
		
		Log.checkpoint("View has loaded", "viewDidLoad", {
			
			super.viewDidLoad()
			
			setupDB()
			
			let m = SQLDB.Meta()
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

protocol SubviewHandler {
	func notifySubview(view: Any)
}

protocol SubviewNotifier {
	func subscribe(_ handler: SubviewHandler)
}
