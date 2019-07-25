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
	func getSmartNextProperty(current: PropertyDataStruct) -> PropertyDataStruct {
		return Property.nextAvailableProperty(current: current)
	}
	
	func isPropertyAlreadyTaken(data: PropertyDataStruct) -> Bool {
		return false
	}
	
	func windowHasLoaded() {
		
	}
	
	func addOrUpdate(data: PropertyDataStruct) {
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
				
				let data = PropertyDataStruct(Name: txtName.stringValue, NumberPrefix: txtNumberPrefix.stringValue, NumberSuffix: txtNumberSuffix.stringValue, DisplayName: "", ElectorCount: 0, Number: Int(txtNumber.stringValue) ?? 0, ID: -1, GPS: "", EID: nil, PID: nil, SID: _street?.ID, PDID: _street?.PDID)

				h.addOrUpdate(data: data)
				let newData = h.getSmartNextProperty(current: data)
				txtName.stringValue = newData.Name
				txtNumberPrefix.stringValue = newData.NumberPrefix
				if newData.Number < 1 {
					txtNumber.stringValue = ""
				}
				else {
					txtNumber.stringValue = "\(newData.Number)"
				}
				txtNumberSuffix.stringValue = newData.NumberSuffix
			}
		}
	}
	
}

protocol NewPropertyWindowDelegate {
	func addOrUpdate(data: PropertyDataStruct)
	func cancel()
	func getSmartNextProperty(current: PropertyDataStruct) -> PropertyDataStruct
	func isPropertyAlreadyTaken(data: PropertyDataStruct) -> Bool
}
