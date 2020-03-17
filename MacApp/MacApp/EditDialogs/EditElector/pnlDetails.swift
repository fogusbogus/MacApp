//
//  pnlDetails.swift
//  MacApp
//
//  Created by Matt Hogg on 01/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import RegisterDB
import SQLDB
import UsefulExtensions

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
	
	//MARK - On-screen properties
	
	public var Title : String {
		get {
			return cboTitle.stringValue
		}
		set {
			cboTitle.stringValue = newValue
		}
	}
	
	public var Forename : String {
		get {
			return txtForename.stringValue
		}
		set {
			txtForename.stringValue = newValue
		}
	}
	
	public var MiddleName : String {
		get {
			return txtMiddle.stringValue
		}
		set {
			txtMiddle.stringValue = newValue
		}
	}
	
	public var Surname : String {
		get {
			return txtSurname.stringValue
		}
		set {
			txtSurname.stringValue = newValue
		}
	}
	
	public var Gender : String {
		get {
			return cboGender.stringValue
		}
		set {
			cboGender.stringValue = newValue
		}
	}
	
	public var NINO : String {
		get {
			return txtNINO.stringValue
		}
		set {
			txtNINO.stringValue = newValue
		}
	}
	
	public var DOB : Date? {
		get {
			return dtDOB.dateValue == Date.distantPast ? nil : dtDOB.dateValue
		}
		set {
			dtDOB.dateValue = newValue ?? Date.distantPast
		}
	}
	
	public var PollingDistrictName : String {
		get {
			return lblPD.stringValue
		}
		set {
			lblPD.stringValue = newValue
		}
	}
	
	public var StreetName : String {
		get {
			return lblStreet.stringValue
		}
		set {
			lblStreet.stringValue = newValue
		}
	}
	
	public var PropertyName : String {
		get {
			return lblProperty.stringValue
		}
		set {
			lblProperty.stringValue = newValue
		}
	}
	

	
	private var _currentData: ElectorDataStruct?
	
	public func loadData(electorData: ElectorDataStruct) {
		_currentData = electorData
		let disp = electorData.getDisplayInformation(db: Databases.shared.Register)
		
		PollingDistrictName = disp["pd"] ?? ""
		StreetName = disp["st"] ?? ""
		PropertyName = disp["pr"] ?? ""

		let md = ElectorMeta(json: electorData.Meta)
		
		Title = md.Title
		Forename = electorData.Forename
		MiddleName = electorData.MiddleName
		Surname = electorData.Surname
		Gender = md.Gender
		DOB = md.DOB ?? Date.distantPast
		NINO = md.NINO
	}
	
	public func getData() -> ElectorDataStruct {
		_currentData = _currentData ?? ElectorDataStruct()
		let md = ElectorMeta(json: _currentData?.Meta ?? "")
		md.Title = Title
		_currentData?.Forename = Forename
		_currentData?.MiddleName = MiddleName
		_currentData?.Surname = Surname
		md.Gender = Gender
		md.DOB = DOB
		md.NINO = NINO
		_currentData?.Meta = md.getSignature()
		return _currentData!
		
	}
}
