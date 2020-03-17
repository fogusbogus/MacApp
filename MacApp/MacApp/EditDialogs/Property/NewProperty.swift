//
//  NewProperty.swift
//  MacApp
//
//  Created by Matt Hogg on 23/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB
import LoggingLib

class NewPropertyWindowController: ModalWindowController, NewPropertyWindowDelegate {
	func getSmartNextProperty(current: PropertyDataStruct) -> PropertyDataStruct {
		return Property.nextAvailableProperty(db: Databases.shared.Register, current: current)
	}
	
	func isPropertyAlreadyTaken(data: PropertyDataStruct) -> Bool {
		return false
	}
	
	func windowHasLoaded() {
		
		Log.checkpoint("windowHasLoaded", {
			
		}, keyAndValues: [:])
		
	}
	
	func addOrUpdate(data: PropertyDataStruct) {
		Log.checkpoint("addOrUpdate", {

			let p = Property(db: Databases.shared.Register, data: data)
			p.save()

		}, keyAndValues: ["data":data])
	}
	
	func cancel() {
		Log.checkpoint("cancel", {
			close()
			refreshDelegate?.refreshStreet()
		}, keyAndValues: [:])
	}
	
	class func loadFromNib() -> NewPropertyWindowController {
		
		let vc = NSStoryboard(name: "NewProperty", bundle: nil).instantiateController(withIdentifier: "NewPropertyWindowController") as! NewPropertyWindowController

		return vc
	}

	
	override func windowDidLoad() {
		super.windowDidLoad()
        // Do view setup here.
		if let vc = self.contentViewController as? NewPropertyVC {
			vc.Log = Log
			vc.handler = self
		}
    }
	
	public func setStreet(street: Street) {
		if let vc = self.contentViewController as? NewPropertyVC {
			vc.Log = Log
			vc.setParentage(street: street)
		}
	}
	
	public var refreshDelegate : StreetVCRefreshDelegate?
	

}

protocol StreetVCRefreshDelegate {
	func refreshStreet()
}

class NSViewControllerWithLog : NSViewController, IIndentLog {
	public var IndentLog_Indent: Int = 0
	
	private var _logFileURL : URL? = nil
	public var IndentLog_URL: URL?
	
	private var _log : IIndentLog? = nil
	public var IndentLog_Instance : IIndentLog? {
		get {
			return _log //?? self
		}
		set {
			_log = newValue
			if newValue != nil {
				IndentLog_URL = newValue!.IndentLog_URL
			}
		}
	}
	
	public var Log : IIndentLog? {
		get {
			return IndentLog_Instance
		}
		set {
			IndentLog_Instance = newValue
		}
	}

	
//	public func IncreaseLogIndent() -> Int {
//		return Log?.ResetLogIndent(LogIndent + 1) ?? 0
//	}
//
//	public func DecreaseLogIndent() -> Int {
//		return Log?.ResetLogIndent(LogIndent - 1) ?? 0
//	}
//
//	public func ResetLogIndent(_ indent: Int) -> Int {
//		LogIndent = indent < 0 ? 0 : indent
//		return LogIndent
//	}

}

class NewPropertyVC : NSViewControllerWithLog {
	
	private var wcMap: PropertyMapWindowController?
	
	func openMapWindow() {
		
		Log.checkpoint("openMapWindow", {
			
			if wcMap == nil {
				wcMap = PropertyMapWindowController.loadFromNib()
				
			}
			
			wcMap?.openModal()
			//NSApp.runModal(for: wcEditElector!.window!)
			//wcEditElector?.showWindow(self)

		}, keyAndValues: [:])
	}
	
	public var handler : NewPropertyWindowDelegate?
	
	private var _street: Street?
	
	public func setParentage(street: Street) {
		_street = street
		lblST.stringValue = street.Name
		lblPD.stringValue = street.PollingDistrictName()
	}
	
	@IBAction func btnMap(_ sender: Any) {
		openMapWindow()
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
		
		Log.checkpoint("btnAdd_Click", {
			
			if sender == btnCancel {
				Log.debug("Cancel pressed")
				if let h = handler {
					h.cancel()
				}
				else {
					//self?.close()
				}
			}
			if sender == btnAdd {
				Log.debug("Add pressed")
				if let h = handler {
					Log.debug("Store current data and get next available number")
					
					let data = PropertyDataStruct(Name: txtName.stringValue, NumberPrefix: txtNumberPrefix.stringValue, NumberSuffix: txtNumberSuffix.stringValue, DisplayName: "", ElectorCount: 0, Number: Int(txtNumber.stringValue) ?? 0, ID: -1, GPS: "", Meta: "", EID: nil, PID: nil, SID: _street?.ID, PDID: _street?.PDID, Split: 0, SplitCount: 0, TodoActions: "", Status: 0)
					
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
		}, keyAndValues: ["sender":sender])
	}
	
}

protocol NewPropertyWindowDelegate {
	func addOrUpdate(data: PropertyDataStruct)
	func cancel()
	func getSmartNextProperty(current: PropertyDataStruct) -> PropertyDataStruct
	func isPropertyAlreadyTaken(data: PropertyDataStruct) -> Bool
}
