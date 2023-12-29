//
//  Site.swift
//  iTour
//
//  Created by Matt Hogg on 20/12/2023.
//

import Foundation
import SwiftData

@Model
class Sight {
	var name: String
	
	init(name: String) {
		self.name = name
	}
}
