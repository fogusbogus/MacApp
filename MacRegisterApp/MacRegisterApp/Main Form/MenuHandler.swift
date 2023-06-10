//
//  MenuHandler.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation

/*
 Tell the main form which side panel to open for the menu action.
 */
extension MacRegisterAppApp : MenuHandler {
	func selected(action: String, data: AnyObject?) {
		if let st = data as? Street {
			switch action {
				case MenuItemIdentifier.newSubStreet.actionCode:
					openWindow(id: "new-ss_\(st.id)", data: st)
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(id: "new-prrange_\(st.id)", data: st)
				default:
					break
			}
		}
		if let pd = data as? PollingDistrict {
			switch action {
				case MenuItemIdentifier.newWard.actionCode:
					openWindow(id: "new-wd_\(pd.id)", data: pd)
				default:
					break
			}
		}
		if let wd = data as? Ward {
			switch action {
				case MenuItemIdentifier.newStreet.actionCode:
					openWindow(id: "new-st_\(wd.id)", data: wd)
				default:
					break
			}
		}
		if let ss = data as? SubStreet {
			switch action {
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(id: "new-prrange_\(ss.id)", data: ss)
				default:
					break
			}
		}
	}

}
