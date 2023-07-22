//
//  App+TreeViewNotifiyDelegate.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 01/07/2023.
//

import Foundation
import TreeView

extension MacRegisterAppApp : TreeViewNotifier {
	func selectionChanged(node: TreeNode?, data: AnyObject?) {
		if let inspectable = data as? DataNavigational {
			print("Inspect: \(inspectable.className) \(inspectable.inspect())")
		}
	}
	
	
}
