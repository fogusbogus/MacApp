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
		
		if let inspectable = data as? DataNavigational {
			print("Inspect: \(inspectable.inspect())")
		}
		
		if let st = data as? Street {
			switch action {
				case MenuItemIdentifier.newSubStreet.actionCode:
					openWindow(window: WindowType(type: .newSubStreet, object: st))
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(window: WindowType(type: .newPropertyRange, object: st))
				case MenuItemIdentifier.deleteStreet.actionCode:
					confirmationDialog.request(type: .delete(item: st), data: st) { stmo in
						if let st = stmo as? Street {
							return "Delete street \(st.objectName) with:\n\n\(st.subStreetCount.withDescription(" substreet"))\n\(st.propertyCount.withDescription(singular: " property", plural: " properties"))\n\(st.electorCount.withDescription(" elector"))"
						}
						return ""
					} onOK: { obj in
						obj?.managedObjectContext?.delete(obj!)
						try? obj?.managedObjectContext?.save()
						updater.toggle.toggle()
					}
				default:
					break
			}
		}
		if let pd = data as? PollingDistrict {
			switch action {
				case MenuItemIdentifier.newWard.actionCode:
					openWindow(window: WindowType(type: .newWard, object: pd))
				case MenuItemIdentifier.deletePollingDistrict.actionCode:
					confirmationDialog.request(type: .delete(item: pd), data: pd) { pdmo in
						if let pd = pdmo as? PollingDistrict {
							return "Delete polling district \(pd.objectName) with:\n\n\(pd.wardCount.withDescription(" ward"))\n\(pd.streetCount.withDescription(" street"))\n\(pd.subStreetCount.withDescription(" substreet"))\n\(pd.propertyCount.withDescription(singular: " property", plural: " properties"))\n\(pd.electorCount.withDescription(" elector"))"
						}
						return ""
					} onOK: { obj in
						obj?.managedObjectContext?.delete(obj!)
						try? obj?.managedObjectContext?.save()
						updater.toggle.toggle()
					}
				default:
					break
			}
		}
		if let wd = data as? Ward {
			switch action {
				case MenuItemIdentifier.newStreet.actionCode:
					openWindow(window: WindowType(type: .newStreet, object: wd))
				case MenuItemIdentifier.deleteWard.actionCode:
					confirmationDialog.request(type: .delete(item: wd), data: wd) { wdmo in
						if let wd = wdmo as? Ward {
							return "Delete ward \(wd.objectName) with:\n\n\(wd.streetCount.withDescription(" street"))\n\(wd.subStreetCount.withDescription(" substreet"))\n\(wd.propertyCount.withDescription(singular: " property", plural: " properties"))\n\(wd.electorCount.withDescription(" elector"))"
						}
						return ""
					} onOK: { obj in
						obj?.managedObjectContext?.delete(obj!)
						try? obj?.managedObjectContext?.save()
						updater.toggle.toggle()
					}
				default:
					break
			}
		}
		if let ss = data as? SubStreet {
			switch action {
				case MenuItemIdentifier.newPropertyRange.actionCode:
					openWindow(window: WindowType(type: .newPropertyRange, object: ss))
				case MenuItemIdentifier.newProperty.actionCode:
					openWindow(window: WindowType(type: .newProperty, object: ss))
				case MenuItemIdentifier.editSubStreet.actionCode:
					openWindow(window: WindowType(type: .editSubStreet, object: ss))
				case MenuItemIdentifier.deleteSubStreet.actionCode:
					confirmationDialog.request(type: .delete(item: ss), data: ss) { mo in
						if let ss = mo as? SubStreet {
							return "Delete substreet \(ss.objectName) with:\n\n\(ss.propertyCount.withDescription(singular: " property", plural: " properties"))\n\(ss.electorCount.withDescription(" elector"))"
						}
						return ""
					} onOK: { obj in
						obj?.managedObjectContext?.delete(obj!)
						try? obj?.managedObjectContext?.save()
						updater.toggle.toggle()
					}

				default:
					break
			}
		}
		if let pr = data as? Abode {
			switch action {
				case MenuItemIdentifier.newElector.actionCode:
					openWindow(window: WindowType(type: .newElector, object: pr))
				case MenuItemIdentifier.editProperty.actionCode:
					openWindow(window: WindowType(type: .editProperty, object: pr))
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

extension Numeric {
	func withDescription(singular: String, plural: String) -> String {
		return "\(self)\(self == 1 ? singular : plural)"
	}
	
	func withDescription(_ singular: String) -> String {
		return withDescription(singular: singular, plural: singular + "s")
	}
}
