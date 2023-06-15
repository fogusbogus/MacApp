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
					openWindow(window: WindowType(type: .newSubStreet, object: st))
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(window: WindowType(type: .newPropertyRange, object: st))
				default:
					break
			}
		}
		if let pd = data as? PollingDistrict {
			switch action {
				case MenuItemIdentifier.newWard.actionCode:
					openWindow(window: WindowType(type: .newWard, object: pd))
				default:
					break
			}
		}
		if let wd = data as? Ward {
			switch action {
				case MenuItemIdentifier.newStreet.actionCode:
					openWindow(window: WindowType(type: .newStreet, object: wd))
				default:
					break
			}
		}
		if let ss = data as? SubStreet {
			switch action {
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(window: WindowType(type: .newPropertyRange, object: ss))
				default:
					break
			}
		}
		if let pr = data as? Abode {
			switch action {
				case MenuItemIdentifier.newElector.actionCode:
					openWindow(window: WindowType(type: .newElector, object: pr))
				default:
					break
			}
		}
		if let el = data as? Elector {
			switch action {
				case MenuItemIdentifier.editElector.actionCode:
					openWindow(window: WindowType(type: .editElector, object: el))
				default:
					break
			}
		}
	}

}
