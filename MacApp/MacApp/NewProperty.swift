//
//  NewProperty.swift
//  MacApp
//
//  Created by Matt Hogg on 23/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB

class NewPropertyWindowController: NSWindowController, NewPropertyWindowDelegate {
	func getSmartNextProperty(current: PropertyData) -> PropertyData {
		let p = Property()
		p.Name = current.Name
		p.NumberPrefix = current.NumberPrefix
		p.Number = current.Number
		p.NumberSuffix = current.NumberSuffix
		p.SID = current.SID
		let np = Property.nextAvailableProperty(current: p)
		var current = current
		current.Name = np.Name
		current.NumberPrefix = np.NumberPrefix
		current.Number = np.Number
		current.NumberSuffix = np.NumberSuffix
		return current
	}
	
	func isPropertyAlreadyTaken(data: PropertyData) -> Bool {
		return false
	}
	
	func windowHasLoaded() {
		
	}
	
	func addOrUpdate(data: PropertyData) {
		print("addOrUpdate")
	}
	
	func cancel() {
		close()
	}
	
	class func loadFromNib() -> NewPropertyWindowController {
		
		let vc = NSStoryboard(name: "NewProperty", bundle: nil).instantiateController(withIdentifier: "NewPropertyWindowController") as! NewPropertyWindowController

		return vc
	}

	
	override func windowDidLoad() {
		super.windowDidLoad()
        // Do view setup here.
		if let vc = self.contentViewController as? NewPropertyVC {
			vc.handler = self
		}
    }
	
	public func setStreet(street: Street) {
		if let vc = self.contentViewController as? NewPropertyVC {
			vc.setParentage(street: street)
		}
	}
    
}

class NewPropertyVC : NSViewController {
	
	public var handler : NewPropertyWindowDelegate?
	
	private var _street: Street?
	
	public func setParentage(street: Street) {
		_street = street
		lblST.stringValue = street.Name
		lblPD.stringValue = street.PollingDistrictName()
	}
	

	@IBOutlet weak var lblPD: NSTextField!
	@IBOutlet weak var lblST: NSTextField!
	@IBOutlet weak var txtName: NSTextField!
	@IBOutlet weak var txtNumberPrefix: NSTextField!
	@IBOutlet weak var txtNumber: NSTextField!
	@IBOutlet weak var txtNumberSuffix: NSTextField!
	@IBOutlet weak var btnAdd: NSButton!
	@IBOutlet weak var btnCancel: NSButton!
	
	@IBAction func btnAdd_Click(_ sender: NSButton) {
		if sender == btnCancel {
			if let h = handler {
				h.cancel()
			}
			else {
				//self?.close()
			}
		}
		if sender == btnAdd {
			if let h = handler {
				let data = PropertyData(ID: -1, Name: txtName.stringValue, NumberPrefix: txtNumberPrefix.stringValue, Number: Int(txtNumber.stringValue) ?? 0, NumberSuffix: txtNumberSuffix.stringValue, GPS: "", SID: _street?.ID ?? -1, PDID: _street?.PDID ?? -1)
				h.addOrUpdate(data: data)
				let newData = h.getSmartNextProperty(current: data)
				txtName.stringValue = newData.Name
				txtNumberPrefix.stringValue = newData.NumberPrefix
				txtNumber.stringValue = "\(newData.Number)"
				txtNumberSuffix.stringValue = newData.NumberSuffix
			}
		}
	}
	
}

struct PropertyData {
	var ID : Int = -1
	var Name : String = ""
	var NumberPrefix : String = ""
	var Number : Int = 0
	var NumberSuffix : String = ""
	var GPS : String = ""
	var SID : Int = -1
	var PDID : Int = -1
}

protocol NewPropertyWindowDelegate {
	func addOrUpdate(data: PropertyData)
	func cancel()
	func getSmartNextProperty(current: PropertyData) -> PropertyData
	func isPropertyAlreadyTaken(data: PropertyData) -> Bool
}
