//
//  TreeNodeDataProvider.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import TreeView

/*
 The treeview and child nodes are not pre-populated, but collected when required. For this to happen cleanly, we need two functions. The first will tell the treeview if a node has any children (and will allow expanding and collapsing as per normal), the second to return the children.
 */
extension MacRegisterAppApp : TreeNodeDataProvider {
	func getChildren(forNode: TreeNode?) -> [TreeNode] {
		guard let forNode = forNode else { return PollingDistrict.getAll().map { TreeNode(text: $0.name ?? "<Unknown PD>", data: $0) } }
		
		if let pd = forNode.data as? PollingDistrict {
			Log.log("Get Wards")
			return pd.getWards().map { TreeNode(text: $0.name ?? "", data: $0)}
		}
		
		if let wd = forNode.data as? Ward {
			Log.log("Get streets")
			return wd.getStreets().map { TreeNode(text: $0.name ?? "", data: $0)}
		}
		
		if let st = forNode.data as? Street {
			Log.log("Get Substreets")
			return st.getSubStreets().map { TreeNode(text: $0.name ?? "", data: $0)}
		}
		
		return []
		
	}
	
	func hasChildren(forNode: TreeNode?) -> Bool {
		guard let forNode = forNode else { return PollingDistrict.getAll().count > 0 }
		
		if let pd = forNode.data as? PollingDistrict {
			return pd.getWards().count > 0
		}
		
		if let wd = forNode.data as? Ward {
			return wd.getStreets().count > 0
		}
		
		if let st = forNode.data as? Street {
			return st.getSubStreets().count > 0
		}
		
		if let ss = forNode.data as? SubStreet {
			return false
		}
		
		return false
	}
}
