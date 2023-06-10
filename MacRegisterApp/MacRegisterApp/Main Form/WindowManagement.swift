//
//  WindowManagement.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

class WindowManagement {
	
	private var ids: [String] = []
	private var views: [any View] = []
	var updater: Updater?
	
	func openWindow(id: String, view: any View) {
		guard !ids.contains(id) else {
			return
		}
		ids.append(id)
		views.append(view)
		updater?.toggle.toggle()
	}
	
	func closeWindow(id: String) {
		guard let idx = ids.firstIndex(of: id) else { return }
		views.remove(at: idx)
		ids.remove(at: idx)
		updater?.toggle.toggle()
	}
	
	func current() -> any View {
		return views.last ?? EmptyView()
	}
}
