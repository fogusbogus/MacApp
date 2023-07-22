//
//  MetaNote.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 29/06/2023.
//

import Foundation

class MetaNote : Codable {
	var ts: Date
	var text: String
	var author: String
	var contact: String			/// email, phone, etc.
	var contactMethod: String	/// Contact type, e.g. email, phone, etc.
}


extension Array where Element : MetaNote {
	/// This may be a legal obligation to remove old data after a certain period.
	/// - Parameters:
	///   - allBeforeTimestamp: Any note before this must be purged
	///   - confirm: We need to be able to allow some kind of confirmation for this. If missing it is assumed DELETE.
	mutating func purgeOutdatedNotes(allBeforeTimestamp: Date, confirm: (([MetaNote]) -> Bool)? = nil) {
		/// Filter the items we need to purge
		let items = self.filter {$0.ts < allBeforeTimestamp}
		
		/// Only confirm if we actually have some items
		if items.count > 0 {
			if let confirm = confirm {
				if confirm(items) {
					self.removeAll(where: {$0.ts < allBeforeTimestamp})
				}
			}
			else {
				self.removeAll(where: {$0.ts < allBeforeTimestamp})
			}
		}
	}
}
