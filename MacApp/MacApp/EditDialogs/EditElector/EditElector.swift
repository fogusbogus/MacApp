//
//  EditElector.swift
//  MacApp
//
//  Created by Matt Hogg on 01/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB

class EditElector: NSSplitViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
	public var handler : EditElectorWindowDelegate?
	
	private var _property: Property?
	
	public func setParentage(property: Property) {
		_property = property
	}
	
	func setElectorData(data: ElectorDataStruct) {
		let pnl = children.first { (vc) -> Bool in
			return vc is pnlDetails
			} as? pnlDetails
		if pnl != nil {
			pnl?.loadData(electorData: data)
		}
	}
}

class EditElectorWindowController: NSWindowController, EditElectorWindowDelegate {
	
	func windowHasLoaded() {
		
	}
	
	func addOrUpdate(data: ElectorDataStruct ) {
		let e = Elector(data: data)
		e.save()
	}
	
	func cancel() {
		close()
		refreshDelegate?.refresh()
	}
	
	class func loadFromNib() -> EditElectorWindowController {
		
		let vc = NSStoryboard(name: "EditElector", bundle: nil).instantiateController(withIdentifier: "EditElectorWindowController") as! EditElectorWindowController
		
		return vc
	}
	
	private var _activeForm : EditElector?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		// Do view setup here.
		if let vc = self.contentViewController as? EditElector {
			vc.handler = self
			_activeForm = self.contentViewController as? EditElector
		}
	}
	
	public func setProperty(property: Property) {
		if let vc = self.contentViewController as? EditElector {
			_activeForm = self.contentViewController as? EditElector
			vc.setParentage(property: property)
		}
	}
	
	public var refreshDelegate : ElectorVCRefreshDelegate?
	
	public func loadElector(elector: Elector) {
		_activeForm?.setElectorData(data: elector.Data)
	}
}

protocol ElectorVCRefreshDelegate {
	func refresh()
}

protocol EditElectorWindowDelegate {
	func addOrUpdate(data: ElectorDataStruct)
	func cancel()
}
