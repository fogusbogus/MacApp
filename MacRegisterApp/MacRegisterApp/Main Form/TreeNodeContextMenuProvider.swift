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
	case newWard, newStreet, newSubStreet, newProperty, newPropertyRange, newElector
	case editPollingDistrict, editWard, editStreet, editSubStreet, editProperty, editElector
	case deletePollingDistrict, deleteWard, deleteStreet, deleteSubStreet, deleteProperty, deleteElector
	
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
				case .newElector:
					return "NEWEL"
					
				
				case .editPollingDistrict:
					return "EDITPD"
				case .editWard:
					return "EDITWD"
				case .editStreet:
					return "EDITST"
				case .editSubStreet:
					return "EDITSS"
				case .editProperty:
					return "EDITPR"
				case .editElector:
					return "EDITEL"
					
				case .deletePollingDistrict:
					return "DELPD"
				case .deleteWard:
					return "DELWD"
				case .deleteStreet:
					return "DELST"
				case .deleteSubStreet:
					return "DELSS"
				case .deleteProperty:
					return "DELPR"
				case .deleteElector:
					return "DELEL"
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
				case .newElector:
					return "New elector(s)..."
					
				case .editPollingDistrict:
					return "Edit Polling District..."
				case .editWard:
					return "Edit Ward..."
				case .editStreet:
					return "Edit Street..."
				case .editSubStreet:
					return "Edit Substreet..."
				case .editProperty:
					return "Edit Property..."
				case .editElector:
					return "Edit Elector..."

				case .deletePollingDistrict:
					return "Delete Polling District..."
				case .deleteWard:
					return "Delete Ward..."
				case .deleteStreet:
					return "Delete Street..."
				case .deleteSubStreet:
					return "Delete Substreet..."
				case .deleteProperty:
					return "Delete Property..."
				case .deleteElector:
					return "Delete Elector..."
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
				Group {
					MenuItem(ident: .newWard, handler: self, data: pd)
					Divider()
					MenuItem(ident: .editPollingDistrict, handler: self, data: pd)
					MenuItem(ident: .deletePollingDistrict, handler: self, data: pd)
				}
			)
		}
		if let wd = data as? Ward {
			return AnyView(
				Group {
					MenuItem(ident: .newStreet, handler: self, data: wd)
					Divider()
					MenuItem(ident: .editWard, handler: self, data: wd)
					MenuItem(ident: .deleteWard, handler: self, data: wd)
				}
			)
		}
		if let st = data as? Street {
			if st.subStreets?.count ?? 0 < 2 {
				return AnyView(
					Group {
						MenuItem(ident: .newSubStreet, handler: self, data: st)
						MenuItem(ident: .newProperty, handler: self, data: st)
						MenuItem(ident: .newPropertyRange, handler: self, data: st)
						Divider()
						MenuItem(ident: .editStreet, handler: self, data: st)
						MenuItem(ident: .deleteStreet, handler: self, data: st)
					}
				)
				
			}
			return AnyView(
				Group {
					MenuItem(ident: .newSubStreet, handler: self, data: st)
					Divider()
					MenuItem(ident: .editStreet, handler: self, data: st)
					MenuItem(ident: .deleteStreet, handler: self, data: st)
				}
			)
		}
		if let ss = data as? SubStreet {
			return AnyView(
				Group {
					MenuItem(ident: .newProperty, handler: self, data: ss)
					MenuItem(ident: .newPropertyRange, handler: self, data: ss)
					Divider()
					MenuItem(ident: .editSubStreet, handler: self, data: ss)
					MenuItem(ident: .deleteSubStreet, handler: self, data: ss)
				}
			)
		}
		return AnyView(EmptyView())
	}
}

protocol ContextMenuProviderDelegate {
	func getContextMenu(data: DataNavigational?) -> AnyView
}
extension MacRegisterAppApp: ContextMenuProviderDelegate {
	func getContextMenu(data: DataNavigational?) -> AnyView {
		guard let data = data else { return AnyView(EmptyView()) }
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
		if let pr = data as? Abode {
			return AnyView(
				Group {
					MenuItem(ident: .newElector, handler: self, data: pr)
					MenuItem(ident: .editProperty, handler: self, data: pr)
				}
			)
		}
		if let el = data as? Elector {
			return AnyView(
				MenuItem(ident: .editElector, handler: self, data: el)
			)
		}
		return AnyView(EmptyView())
	}
	
	
}
