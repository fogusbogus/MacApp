//
//  Settings.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 30/07/2023.
//

import Foundation
import SwiftUI

typealias HexColor = String?

// These settings are held against the user record
class Settings: Codable {
	
	init() {
		self.general = Settings_General()
		self.ticket = Settings_Ticket()
		self.lane = Settings_Lane()
		self.user = Settings_User()
		self.tag = Settings_Tag()
	}
	
	enum CodingKeys: String, CodingKey {
		case general, ticket, lane, user, tag
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.general = try container.decodeIfPresent(Settings_General.self, forKey: .general) ?? Settings_General()
		self.ticket = try container.decodeIfPresent(Settings_Ticket.self, forKey: .ticket) ?? Settings_Ticket()
		self.lane = try container.decodeIfPresent(Settings_Lane.self, forKey: .lane) ?? Settings_Lane()
		self.user = try container.decodeIfPresent(Settings_User.self, forKey: .user) ?? Settings_User()
		self.tag = try container.decodeIfPresent(Settings_Tag.self, forKey: .tag) ?? Settings_Tag()
	}
	
	var general: Settings_General
	var ticket: Settings_Ticket
	var lane: Settings_Lane
	var user: Settings_User
	var tag: Settings_Tag
}

