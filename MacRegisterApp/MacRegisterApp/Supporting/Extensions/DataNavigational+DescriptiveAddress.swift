//
//  DataNavigational+DescriptiveAddress.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI

extension View {
	
	func contextMenuForWholeItem() -> some View {
		return self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
			.contentShape(Rectangle())
	}
	/*
	 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
	 .contentShape(Rectangle())
	 .contextMenu(menuItems: {contextMenuDelegate?.getContextMenu(data: delegate?.getSelectedAbode())})
	 */
}

extension Abode {
	var describe: String? {
		get {
			return "\(name ?? "?") \(subStreet?.describe ?? "unknown street")"
		}
	}
	var location: String {
		get {
			//11 Berkeley Close, Cainscross, Stroud
			var parts: [String] = [describe!]
//			if let ss = subStreet?.describe {
//				parts.append(ss)
//			}
//			else {
//				if let st = subStreet?.street?.describe {
//					parts.append(st)
//				}
//			}
			if let wd = subStreet?.street?.ward?.describe {
				parts.append(wd)
			}
			if let pd = subStreet?.street?.ward?.pollingDistrict?.describe {
				parts.append(pd)
			}
			return parts.joined(separator: ", ")
		}
	}
}


extension SubStreet {
	var describe: String? {
		get {
			var ret = ""
			if let st = street {
				if let stName = st.name {
					ret = stName
				}
			}
			if !objectName.isEmptyOrWhitespace() {
				ret += " (\(objectName))"
				if (street?.objectName ?? "").isEmptyOrWhitespace() {
					ret += " in Unknown Street"
				}
			}
			ret = ret.trim()
			if ret.isEmptyOrWhitespace() {
				return nil
			}
			return ret
		}
	}
	var location: String {
		get {
			var parts: [String] = []
			if let d = describe {
				parts.append(d)
			}
			if let wd = street?.ward?.describe {
				parts.append(wd)
			}
			if let pd = street?.ward?.pollingDistrict?.describe {
				parts.append(pd)
			}
			return parts.joined(separator: ", ")
		}
	}
}

extension Street {
	var describe: String? {
		get {
			let ret = name ?? ""
			if ret.isEmptyOrWhitespace() {
				return nil
			}
			return ret.trim()
		}
	}
	var location: String {
		get {
			var parts: [String] = []
			if let d = describe {
				parts.append(d)
			}
			if let wd = ward?.describe {
				parts.append(wd)
			}
			if let pd = ward?.pollingDistrict?.describe {
				parts.append(pd)
			}
			return parts.joined(separator: ", ")
		}
	}
}

extension Ward {
	var describe: String? {
		get {
			let ret = name ?? ""
			if ret.isEmptyOrWhitespace() {
				return nil
			}
			return ret.trim()
		}
	}
	var location: String {
		get {
			var parts: [String] = []
			if let d = describe {
				parts.append(d)
			}
			if let pd = pollingDistrict?.describe {
				parts.append(pd)
			}
			return parts.joined(separator: ", ")
		}
	}
}

extension PollingDistrict {
	var describe: String? {
		get {
			let ret = name ?? ""
			if ret.isEmptyOrWhitespace() {
				return nil
			}
			return ret.trim()
		}
	}
}

