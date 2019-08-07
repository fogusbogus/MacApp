//
//  pnlButtons.swift
//  MacApp
//
//  Created by Matt Hogg on 06/08/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class pnlButtons: NSViewController {

	@IBOutlet weak var btnSave: NSButton!
	@IBOutlet weak var btnNext: NSButton!
	@IBOutlet weak var btnEdit: NSButton!
	@IBOutlet weak var btnDelete: NSButton!
	@IBOutlet weak var btnCancel: NSButton!
	@IBAction func Save_Click(_ sender: NSButton) {
		handler?.action(_formUseType)
	}
	@IBAction func Cancel_Click(_ sender: NSButton) {
		handler?.cancel()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		FormUsage = _formUseType
    }
	
	public var handler: EditableFormButtonDelegate?
	
	private var _formUseType: FormUseType = .notSpecified
	public var FormUsage : FormUseType {
		get {
			return _formUseType
		}
		set {
			_formUseType = newValue
			
			btnCancel.isHidden = false
			
			btnSave.isHidden = newValue != .edit
			btnNext.isHidden = newValue != .new
			btnDelete.isHidden = newValue != .remove
			btnEdit.isHidden = newValue != .view
		}
	}
}

protocol EditableFormButtonDelegate {
	func action(_ usage: FormUseType)
	func cancel()
}

public enum FormUseType {
	case edit
	case new
	case view
	case remove
	case notSpecified
}
