//
//  TreeViewUI.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI
import TreeView

extension MacRegisterAppApp : TreeViewUIDelegate {
	func update() {
		
	}
	
	func select(node: TreeNode?) {
		updater.toggle.toggle()
	}
	
}
