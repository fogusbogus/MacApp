//
//  App+LatestWindow.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 16/06/2023.
//

import SwiftUI

enum ActionType {
	case edit, new, delete
}

extension MacRegisterAppApp {
	
	func openWindow(window: WindowType) {
		detail = detail.filter {$0 != window}
		detail.append(window)
	}

	func latestWindow() -> AnyView {
		guard let window = detail.last else { return AnyView(currentWindowForSelection())}
		
		switch window.type {
			case .newSubStreet:
				return AnyView(
					Group {
						NewSubStreet(street: window.object as? Street, delegate: self)
						Spacer()
					})
			case .newWard:
				return AnyView(
					Group {
						NewWard(pollingDistrict: window.object as? PollingDistrict, delegate: self)
						Spacer()
					})
				
			case .deleteWard:
				return AnyView(
					Group {
						NewWard(pollingDistrict: window.object as? PollingDistrict, delegate: self)
					}
				)
				
			case .newStreet:
				return AnyView(
					Group {
						NewStreet(ward: window.object as? Ward, delegate: self)
						Spacer()
					})
			case .newPropertyRange:
				let st = window.object as? Street ?? (window.object as? SubStreet)?.street
				let ss = window.object as? SubStreet
				return AnyView(
					Group {
						NewPropertyRange(subStreet: ss, street: st, delegate: self)
						Spacer()
					})
				
			case .newElector:
				return AnyView(
					Group {
						NewElector(property: window.object as? Abode, delegate: self)
						Spacer()
					})
				
			case .editElector:
				electorDetails.load(object: selectedElector)
				return AnyView(
					Group {
						NewElector(property: nil, delegate: self, details: electorDetails)
						Spacer()
					}
				)
				
			case .newProperty:
				if let ss = window.object as? SubStreet {
					propertyDetails.load(object: nil)
					return AnyView(
						Group {
							NewProperty(subStreet: ss, delegate: self, details: propertyDetails)
							Spacer()
						}
					)
				}
				if let st = window.object as? Street {
					if let ss = st.getSubStreets().last {
						propertyDetails.load(object: nil)
						return AnyView(
							Group {
								NewProperty(subStreet: ss, delegate: self, details: propertyDetails)
								Spacer()
							}
						)
					}
				}
				return AnyView(EmptyView())
				
			case .editProperty:
				propertyDetails.load(object: currentAbode)

				return AnyView(
					Group {
						NewProperty(subStreet: nil, delegate: self, details: PropertyDetails(object: currentAbode))
						Spacer()
					}
				)
				
			case .editSubStreet:
				if let ss = window.object as? SubStreet {
					subStreetDetails.load(object: ss)
					return AnyView(
						Group {
							NewSubStreet(street: nil, delegate: self, details: subStreetDetails)
							Spacer()
						}
					)
				}
				return AnyView(EmptyView())
				
			case .editStreet:
				if let st = window.object as? Street {
					streetDetails.load(object: st)
					return AnyView(
						Group {
							NewStreet(ward: nil, delegate: self, details: streetDetails, editMode: true)
						}
					)
				}
				return AnyView(EmptyView())

			default:
				return AnyView(currentWindowForSelection())
		}
	}

	func currentWindowForSelection() -> AnyView {
		
		if let pd = tree.selectedNode?.data as? PollingDistrict {
			return AnyView(
				Group {
					View_PollingDistrict(data: View_PollingDistrict_Data(pollingDistrict: pd), delegate: self)
					Spacer()
				}
			)
		}
		if let wd = tree.selectedNode?.data as? Ward {
			return AnyView(
				Group {
					View_Ward(data: View_Ward_Data(ward: wd), delegate: self)
					Spacer()
				}
			)
		}
		if let st = tree.selectedNode?.data as? Street {
			streetDetails.load(object: st)
			return AnyView(
				VStack {
					HStack {
						NewStreet(ward: nil, delegate: self, details: streetDetails, editMode: false)
//						View_Street(data: View_Street_Data(street: st), delegate: self)
						Spacer()
					}
					HSplitView {
						PropertiesView(street: st, delegate: self, contextMenuDelegate: self)
						View_Electors(property: currentAbode, contextMenuDelegate: self, delegate: self)
					}
				}
			)
		}
		if let ss = tree.selectedNode?.data as? SubStreet {
			return AnyView(
				VStack {
					HStack {
						View_SubStreet(data: View_SubStreet_Data(subStreet: ss), delegate: self)
						Spacer()
					}
					HSplitView {
						PropertiesView(substreet: ss, delegate: self, contextMenuDelegate: self)
						View_Electors(property: currentAbode, contextMenuDelegate: self, delegate: self)
					}
				}
			)
		}
		return AnyView(EmptyView())
	}
}
