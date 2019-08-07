//
//  EditElector.swift
//  MacApp
//
//  Created by Matt Hogg on 01/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB

class EditElector: NSSplitViewController, EditElectorButtonDelegate {
	func save() {
		handler?.addOrUpdate(data: _pnlDetails!.getData())
	}
	
	func cancel() {
		handler?.cancel()
	}
	

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
		
		//Okay, we have some combos to set up
		let titles : [String] = ["Mr", "Mrs", "Miss", "Ms", "Dr", "Prof", "Gen", "Maj", "Sgt", "May", "Sir", "Dame"]
		assertPanels()
		if _pnlDetails != nil {
			_pnlDetails?.cboTitle.addItems(withObjectValues: titles)
			_pnlDetails?.cboGender.removeAllItems()
			_pnlDetails?.cboGender.addItems(withObjectValues: ["Male", "Female"])
		}
		
		_pnlButtons?.handler = self
	}
	
	private func assertPanels() {
		_pnlDetails = _pnlDetails ?? children.first { (vc) -> Bool in
			return vc is pnlDetails
			} as? pnlDetails
		_pnlButtons = _pnlButtons ?? children.first { (vc) -> Bool in
			return vc is pnlButtons
			} as? pnlButtons
	}
	
	public var handler : EditElectorWindowDelegate?
	
	private var _property: Property?
	
	public func setParentage(property: Property) {
		_property = property
	}
	
	private var _pnlDetails : pnlDetails?
	private var _pnlButtons : pnlButtons?
	
	func setElectorData(data: ElectorDataStruct) {
		assertPanels()
		_pnlButtons?.handler = self

		_pnlDetails?.loadData(electorData: data)
	}
}

class EditElectorWindowController: NSWindowController, EditElectorWindowDelegate {
	
	func windowHasLoaded() {
		
	}
	
	func addOrUpdate(data: ElectorDataStruct ) {
		let e = Elector(data: data)
		e.save()
		refreshDelegate?.refreshElector()
	}
	
	func cancel() {
		close()
		refreshDelegate?.refreshElector()
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
	func refreshElector()
}

protocol EditElectorWindowDelegate {
	func addOrUpdate(data: ElectorDataStruct)
	func cancel()
}
