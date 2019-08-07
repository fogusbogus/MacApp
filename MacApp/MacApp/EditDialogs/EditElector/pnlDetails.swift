//
//  pnlDetails.swift
//  MacApp
//
//  Created by Matt Hogg on 01/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB
import DBLib
import Common

class pnlDetails: NSViewController {

	@IBOutlet weak var lblPD: NSTextField!
	@IBOutlet weak var lblStreet: NSTextField!
	@IBOutlet weak var lblProperty: NSTextField!
	@IBOutlet weak var cboTitle: NSComboBox!
	@IBOutlet weak var txtForename: NSTextField!
	@IBOutlet weak var txtMiddle: NSTextField!
	@IBOutlet weak var txtSurname: NSTextField!
	
	@IBOutlet weak var cboGender: NSComboBox!
	
	@IBOutlet weak var dtDOB: NSDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	
	private var _currentData: ElectorDataStruct?
	
	public func loadData(electorData: ElectorDataStruct) {
		_currentData = electorData
		let disp = electorData.getDisplayInformation()
		
		lblPD.stringValue = disp["pd"] ?? ""
		lblStreet.stringValue = disp["st"] ?? ""
		lblProperty.stringValue = disp["pr"] ?? ""

		let md = Meta(json: electorData.Meta)
		
		cboTitle.stringValue = md.get("title", "")
		txtForename.stringValue = electorData.Forename
		txtMiddle.stringValue = electorData.MiddleName
		txtSurname.stringValue = electorData.Surname
		cboGender.stringValue = md.get("gender", "")
		dtDOB.stringValue = md.get("dob", Date().description)
	}
	
	public func getData() -> ElectorDataStruct {
		_currentData = _currentData ?? ElectorDataStruct()
		var md = Meta(json: _currentData?.Meta ?? "")
		md.set("title", cboTitle.stringValue)
		_currentData?.Forename = txtForename.stringValue
		_currentData?.MiddleName = txtMiddle.stringValue
		_currentData?.Surname = txtSurname.stringValue
		md.set("gender", cboGender.stringValue)
		md.set("dob", dtDOB.stringValue)
		return _currentData!
		
	}
}
