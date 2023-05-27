//
//  MenuItem.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 26/05/2023.
//

import Foundation
import SwiftUI

protocol MenuHandler {
	func selected(action: String, data: AnyObject?)
}

struct MenuItem : View {
	
	private var label: String = "", handler: MenuHandler? = nil, action: String = "", data: AnyObject? = nil, callback: ((String, AnyObject?) -> Void)? = nil
	
	init(_ label: String, _ handler: MenuHandler? = nil, _ action: String = "", _ data: AnyObject? = nil) {
		self.label = label
		self.handler = handler
		self.action = action
		self.data = data
	}
	init(_ label: String, _ handler: ((String, AnyObject?) -> Void)? = nil, _ action: String = "", _ data: AnyObject? = nil) {
		self.label = label
		self.callback = handler
		self.action = action
		self.data = data
	}
	var body: some View {
		Button {
			handler?.selected(action: action, data: data)
			callback?(action, data)
		} label: {
			Text(label)
		}
	}
}
