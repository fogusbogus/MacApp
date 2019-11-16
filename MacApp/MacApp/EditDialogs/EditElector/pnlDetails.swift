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
	@IBOutlet weak var txtNINO: NSTextField!
	
	@IBOutlet weak var dtDOB: NSDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
	
	private var _currentData: ElectorDataStruct?
	
	public func loadData(electorData: ElectorDataStruct) {
		_currentData = electorData
		let disp = electorData.getDisplayInformation(db: Databases.shared.Register)
		
		lblPD.stringValue = disp["pd"] ?? ""
		lblStreet.stringValue = disp["st"] ?? ""
		lblProperty.stringValue = disp["pr"] ?? ""

		let md = ElectorMeta(json: electorData.Meta)
		
		cboTitle.stringValue = md.Title
		txtForename.stringValue = electorData.Forename
		txtMiddle.stringValue = electorData.MiddleName
		txtSurname.stringValue = electorData.Surname
		cboGender.stringValue = md.Gender
		dtDOB.dateValue = md.DOB ?? Date()
		txtNINO.stringValue = md.NINO
	}
	
	public func getData() -> ElectorDataStruct {
		_currentData = _currentData ?? ElectorDataStruct()
		let md = ElectorMeta(json: _currentData?.Meta ?? "")
		md.Title = cboTitle.stringValue
		_currentData?.Forename = txtForename.stringValue
		_currentData?.MiddleName = txtMiddle.stringValue
		_currentData?.Surname = txtSurname.stringValue
		md.Gender = cboGender.stringValue
		md.DOB = dtDOB.dateValue
		md.NINO = txtNINO.stringValue
		_currentData?.Meta = md.getSignature()
		return _currentData!
		
	}
}
