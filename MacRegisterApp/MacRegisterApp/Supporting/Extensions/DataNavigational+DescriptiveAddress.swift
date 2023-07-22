//
//  DataNavigational+DescriptiveAddress.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 10/06/2023.
//

import Foundation
import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers
import TreeView

struct NavDataIdentifier : Codable {
	var type: String
	var objectID: String
	
	static func from(object: DataNavigational?) -> NavDataIdentifier {
		var ret = NavDataIdentifier(type: "", objectID: "")
		if let o = object {
			ret.type = o.className
			ret.objectID = String(describing: o.objectID)
		}
		return ret
	}
}

extension NavDataIdentifier : Transferable {
	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .dataNavigationItem)
	}
}


extension UTType {
	static var dataNavigationItem: UTType { UTType(exportedAs: "com.fogusbogus.MacRegisterApp.DataNavigationItem") }
}

//class DataNavigationItem: Codable, Transferable {
//
//	enum CodingKeys: String, CodingKey {
//		case type, objectID
//	}
//
//	public var type: DataNavigationalType
//	private var objectID: String = ""
//
//	var object: NSManagedObject?
//
//	init(object: NSManagedObject) {
//		self.object = object
//		self.objectID = String(describing: object.objectID)
//		type = .pollingDistrict
//		if object is Ward {
//			type = .ward
//		}
//		if object is Street {
//			type = .street
//		}
//		if object is SubStreet {
//			type = .subStreet
//		}
//		if object is Abode {
//			type = .abode
//		}
//		if object is Elector {
//			type = .elector
//		}
//	}
//
//	static var transferRepresentation: some TransferRepresentation {
//		CodableRepresentation(contentType: .dataNavigationItem)
//	}
//
//	required init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		let myType = try values.decode(String.self, forKey: .type)
//		type = DataNavigationalType(rawValue: myType)!
//		objectID = try values.decode(String.self, forKey: .objectID)
//		switch type {
//			case .pollingDistrict:
//				object = PollingDistrict.findById(id: objectID)
//			case .ward:
//				object = Ward.findById(id: objectID)
//			case .street:
//				object = Street.findById(id: objectID)
//			case .subStreet:
//				object = SubStreet.findById(id: objectID)
//			case .abode:
//				object = Abode.findById(id: objectID)
//			case .elector:
//				object = Elector.findById(id: objectID)
//		}
//	}
//
//	func encode(to encoder: Encoder) throws {
//		var values = encoder.container(keyedBy: CodingKeys.self)
//		try values.encode(type.rawValue, forKey: .type)
//		try values.encode(objectID, forKey: .objectID)
//	}
//}

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

