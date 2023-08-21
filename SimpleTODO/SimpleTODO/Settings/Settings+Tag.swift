//
//  Settings+Tag.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 02/08/2023.
//

import Foundation
import SwiftUI

class Settings_Tag: Codable {
	
	init() {
		self.backgroundColor = ColorHelper.Named(named: "Colors/Tag/back") ?? ColorHelper.clear
		self.borderColor = ColorHelper.Named(named: "Colors/Tag/border") ?? ColorHelper.clear
		self.borderWidth = 1
		self.cornerRadius = 25
		self.foregroundColor = ColorHelper.Named(named: "Colors/Tag/fore") ?? ColorHelper.clear
	}
	
	enum CodingKeys: String, CodingKey {
		case backgroundColor, foregroundColor, borderColor, borderWidth, cornerRadius
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		backgroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .backgroundColor))
		foregroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .foregroundColor))
		borderColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .borderColor))
		self.borderWidth = CGFloat(try values.decode(Float.self, forKey: .borderWidth))
		self.cornerRadius = CGFloat(try values.decode(Float.self, forKey: .cornerRadius))
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(backgroundColor.hexString, forKey: .backgroundColor)
		try container.encode(foregroundColor.hexString, forKey: .foregroundColor)
		try container.encode(borderColor.hexString, forKey: .borderColor)
		try container.encode(borderWidth, forKey: .borderWidth)
		try container.encode(cornerRadius, forKey: .cornerRadius)
	}
	
	var backgroundColor: CGColor
	var foregroundColor: CGColor
	var borderColor: CGColor
	var borderWidth: CGFloat
	var cornerRadius: CGFloat
}

class ColorHelper {
	static var clear: CGColor {
		get {
#if os(iOS)
			return UIColor.clear.cgColor
#else
			return .clear
#endif
		}
	}
	static func Color(hex: String, alpha: Double = 1.0, defaultColor: CGColor = clear) -> CGColor {
		return CGColor.fromHex(hex)
	}
	
	static func Named(named: String) -> CGColor? {
#if os(iOS)
		return UIColor(named: named)?.cgColor
#else
		return NSColor(named: named)?.cgColor
#endif
	}
}
