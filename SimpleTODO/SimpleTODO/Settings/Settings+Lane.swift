//
//  Settings+Lane.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 31/07/2023.
//

import Foundation
import SwiftUI


class Settings_Lane: Codable {
	
	init() {
		self.backgroundColor = ColorHelper.Named(named: "Colors/Lane/back") ?? ColorHelper.clear
		self.borderColor = ColorHelper.Named(named: "Colors/Lane/border") ?? ColorHelper.clear
		self.borderWidth = 1
		self.cornerRadius = 25
		self.foregroundColor = ColorHelper.Named(named: "Colors/Lane/fore") ?? ColorHelper.clear
		self.targetedBackgroundColor = ColorHelper.Named(named: "Colors/Lane/backwhentargeted") ?? ColorHelper.clear
		self.ticketSpacing = 24
	}
	
	enum CodingKeys: String, CodingKey {
		case backgroundColor, foregroundColor, borderColor, targetedBackgroundColor, borderWidth, cornerRadius, ticketSpacing
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		backgroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .backgroundColor))
		foregroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .foregroundColor))
		borderColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .borderColor))
		targetedBackgroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .targetedBackgroundColor))
		self.borderWidth = CGFloat(try values.decode(Float.self, forKey: .borderWidth))
		self.cornerRadius = CGFloat(try values.decode(Float.self, forKey: .cornerRadius))
		self.ticketSpacing = CGFloat(try values.decode(Float.self, forKey: .ticketSpacing))
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(backgroundColor.hexString, forKey: .backgroundColor)
		try container.encode(foregroundColor.hexString, forKey: .foregroundColor)
		try container.encode(borderColor.hexString, forKey: .borderColor)
		try container.encode(targetedBackgroundColor.hexString, forKey: .targetedBackgroundColor)
		try container.encode(borderWidth, forKey: .borderWidth)
		try container.encode(cornerRadius, forKey: .cornerRadius)
		try container.encode(ticketSpacing, forKey: .ticketSpacing)
	}
	
	var backgroundColor: CGColor
	var foregroundColor: CGColor
	var borderColor: CGColor
	var targetedBackgroundColor: CGColor
	var borderWidth: CGFloat
	var cornerRadius: CGFloat
	var ticketSpacing: CGFloat
}

