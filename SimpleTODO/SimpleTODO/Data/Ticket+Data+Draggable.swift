//
//  Ticket+Data+Draggable.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 23/07/2023.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable

extension UTType {
	static var ticket: UTType { UTType(exportedAs: "com.fogusbogus.SimpleTODO.ticket") }
}

struct TicketData : Codable, Transferable {
	
	var id: String
	
	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .ticket)
	}
}


