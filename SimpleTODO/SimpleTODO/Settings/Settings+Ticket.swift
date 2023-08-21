//
//  Settings+Ticket.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 31/07/2023.
//

import Foundation
import SwiftUI

class Settings_Ticket: Codable {
	
	init() {
		self.backgroundColor = ColorHelper.Named(named: "Colors/Ticket/back") ?? ColorHelper.clear
		self.borderColor = ColorHelper.Named(named: "Colors/Ticket/border") ?? ColorHelper.clear
		self.foregroundColor = ColorHelper.Named(named: "Colors/Ticket/fore") ?? ColorHelper.clear
		self.borderWidth = 2
		self.cornerRadius = 25
		self.ticketIDPrioritySpacing = 0
		self.symbolSize = 24
		self.prioritySymbols = [
			0:"0.circle.fill",
			1:"1.circle.fill",
			2:"2.circle.fill",
			3:"3.circle.fill",
			4:"4.circle.fill",
			5:"5.circle.fill",
			6:"6.circle.fill",
			7:"7.circle.fill",
			8:"8.circle.fill",
			9:"9.circle.fill"
		]
	}
	
	enum CodingKeys: String, CodingKey {
		case backgroundColor, foregroundColor, borderColor, borderWidth, cornerRadius, ticketIDPrioritySpacing, prioritySymbols, symbolSize
	}
	
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		backgroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .backgroundColor))
		foregroundColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .foregroundColor))
		borderColor = ColorHelper.Color(hex: try values.decode(String.self, forKey: .borderColor))
		self.borderWidth = CGFloat(try values.decode(Float.self, forKey: .borderWidth))
		self.cornerRadius = CGFloat(try values.decode(Float.self, forKey: .cornerRadius))
		self.ticketIDPrioritySpacing = CGFloat(try values.decode(Float.self, forKey: .ticketIDPrioritySpacing))
		self.symbolSize = CGFloat(try values.decode(Float.self, forKey: .symbolSize))
		let priorities = try values.decode([String:String].self, forKey: .prioritySymbols)
		prioritySymbols = [:]
		priorities.forEach { kv in
			prioritySymbols[Int(kv.key)!] = kv.value
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(backgroundColor.hexString, forKey: .backgroundColor)
		try container.encode(foregroundColor.hexString, forKey: .foregroundColor)
		try container.encode(borderColor.hexString, forKey: .borderColor)
		try container.encode(borderWidth, forKey: .borderWidth)
		try container.encode(cornerRadius, forKey: .cornerRadius)
		try container.encode(ticketIDPrioritySpacing, forKey: .ticketIDPrioritySpacing)
		try container.encode(symbolSize, forKey: .symbolSize)
		var dict: [String:String] = [:]
		prioritySymbols.forEach {dict["\($0.key)"] = $0.value }
		try container.encode(dict, forKey: .prioritySymbols)
	}
	
	var backgroundColor: CGColor
	var foregroundColor: CGColor
	var borderColor: CGColor
	var borderWidth: CGFloat
	var cornerRadius: CGFloat
	var ticketIDPrioritySpacing: CGFloat
	var prioritySymbols: [Int:String]
	var symbolSize: CGFloat
}

