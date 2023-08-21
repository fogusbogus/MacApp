//
//  Settings+User.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 31/07/2023.
//

import Foundation

class Settings_User: Codable {
	
	init() {
		showIcon = true
	}
	
	var showIcon: Bool
}
