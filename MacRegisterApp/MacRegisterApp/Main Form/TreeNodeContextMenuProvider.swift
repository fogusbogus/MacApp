//
//  TreeNodeContextMenuProvider.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import TreeView
import SwiftUI

enum MenuItemIdentifier {
	case newWard, newStreet, newSubStreet, newProperty, newPropertyRange
	
	var actionCode: String {
		get {
			switch self {
				case .newWard:
					return "NEWWD"
				case .newStreet:
					return "NEWST"
				case .newSubStreet:
					return "NEWSS"
				case .newProperty:
					return "NEWPR"
				case .newPropertyRange:
					return "NEWPRRANGE"
			}
		}
	}
	
	var prompt: String {
		get {
			switch self {
				case .newWard:
					return "New Ward..."
				case .newStreet:
					return "New Street..."
				case .newSubStreet:
					return "New Substreet..."
				case .newProperty:
					return "New Property..."
				case .newPropertyRange:
					return "New Property Range..."
			}
		}
	}
}

/*
 Right-click menu for the treeview. We will need a separate one for the list views and data forms
 */
extension MacRegisterAppApp : TreeNodeContextMenuProvider {
	func getContextMenu(node: TreeNode) -> AnyView {
		guard let data = node.data else { return AnyView(EmptyView()) }
		if let pd = data as? PollingDistrict {
			return AnyView(
				MenuItem(ident: .newWard, handler: self, data: pd)
			)
		}
		if let wd = data as? Ward {
			return AnyView(
				MenuItem(ident: .newStreet, handler: self, data: wd)
			)
		}
		if let st = data as? Street {
			if st.subStreets?.count ?? 0 < 2 {
				return AnyView(
					Group {
						MenuItem(ident: .newSubStreet, handler: self, data: st)
						Divider()
						MenuItem(ident: .newProperty, handler: self, data: st)
						MenuItem(ident: .newPropertyRange, handler: self, data: st)
					}
				)
				
			}
			return AnyView(
				MenuItem(ident: .newSubStreet, handler: self, data: st)
			)
		}
		if let ss = data as? SubStreet {
			return AnyView(
				Group {
					MenuItem(ident: .newProperty, handler: self, data: ss)
					MenuItem(ident: .newPropertyRange, handler: self, data: ss)
				}
			)
		}
		return AnyView(EmptyView())
	}

}
