//
//  MenuHandler+DialogType.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 15/07/2023.
//

import Foundation
import CoreData


class ConfirmationDialog : ObservableObject {
	enum ConfirmationType {
		case none, delete(item: NSManagedObject)
	}
	
	init(type: ConfirmationType = .none, data: NSManagedObject? = nil, onOK: @escaping (NSManagedObject?) -> Void, onCancel: ((NSManagedObject?) -> Void)? = nil) {
		self.showDialog = false
		self.onOK = onOK
		self.onCancel = onCancel
		self.data = data
		self.type = type
	}
	
	var data: NSManagedObject?
	var onOK: (NSManagedObject?) -> Void
	var onCancel: ((NSManagedObject?) -> Void)?
	var message: String = ""
	var okText: String = "OK"
	var cancelText: String = ""

	func request(type: ConfirmationType, data: NSManagedObject, message: String, okText: String = "OK", cancelText: String = "Cancel", onOK: ((NSManagedObject?) -> Void)? = nil) {
		self.data = data
		self.message = message
		self.okText = okText
		self.cancelText = cancelText
		self.type = type
		if let onOK = onOK {
			self.onOK = onOK
		}
	}
	func request(type: ConfirmationType, data: NSManagedObject, getMessage: (NSManagedObject) -> String, okText: String = "OK", cancelText: String = "Cancel", onOK: ((NSManagedObject?) -> Void)? = nil) {
		self.data = data
		self.message = getMessage(data)
		self.okText = okText
		self.cancelText = cancelText
		self.type = type
		if let onOK = onOK {
			self.onOK = onOK
		}
	}
	
	var type: ConfirmationType {
		didSet {
			switch type {
				case .none:
					showDialog = false
				default:
					showDialog = true
			}
		}
	}
	
	@Published var showDialog: Bool
}

/*
 .confirmationDialog("Are you sure?",
 isPresented: $isPresentingConfirm) {
 Button("Delete all items?", role: .destructive) {
 store.deleteAll()
 }
 }
 */
