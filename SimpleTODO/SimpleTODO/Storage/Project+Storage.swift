//
//  Project+Storage.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 21/08/2023.
//

import Foundation

class Storage_Project: Codable {
	
	init() {
		name = ""
		createdTS = .now
		createdByUser = ""
		users = []
		userPool = []
		tickets = []
		lanes = []
		tags = []
		categories = []
	}
	
	var name: String
	var createdTS: Date
	var createdByUser: Storage_User.ID
	var users: [Storage_User]
	var userPool: [Storage_User.ID]
	var tickets: [Storage_Ticket]
	var lanes: [Storage_Lane]
	var tags: [Storage_Tag]
	var categories: [Storage_Category]
	
	static func create(_ project: TODOProject) -> Storage_Project {
		var ret = Storage_Project()
		ret.name = project.name ?? ""
		ret.createdTS = project.createdTS ?? .now
		if let user = project.createdBy {
			ret.createdByUser = String(describing: user.objectID)
		}
		User.getAll().forEach {ret.users.append(Storage_User.create($0))}
		project.tickets?.allObjects.forEach {ret.tickets.append(Storage_Ticket.create($0 as! Ticket))}
		project.lanes?.allObjects.forEach {ret.lanes.append(Storage_Lane.create($0 as! Lane))}
		TagPool.getAll().forEach {ret.tags.append(Storage_Tag.create($0 ))}
		Category.getAll().forEach {ret.categories.append(Storage_Category.create($0))}
		
		project.userPool?.allObjects.forEach {ret.userPool.append(String(describing: ($0 as! User).objectID))}

		return ret
	}
}

class Storage_General {
	typealias ColorRef = String
}

class Storage_Category: Codable {
	typealias ID = String
	
	init() {
		id = ""
		code = ""
		createdTS = .now
		iteration = 0
		name = ""
		createdByUser = ""
	}
	
	var id: ID
	var code: String
	var createdTS: Date
	var iteration: Int
	var name: String
	var createdByUser: Storage_User.ID
	
	static func create(_ cat: Category) -> Storage_Category {
		let ret = Storage_Category()
		
		ret.id = String(describing: cat.objectID)
		ret.code = cat.code ?? ret.code
		ret.createdTS = cat.created ?? ret.createdTS
		ret.name = cat.name ?? ret.name
		if let user = cat.createdBy {
			ret.createdByUser = String(describing: user.objectID)
		}
		return ret
	}

}

class Storage_User: Codable {
	typealias ID = String
	
	init() {
		id = ""
		createdTS = .now
		name = ""
		icon = ""
		iconBackgroundColor = "#00000000"
		iconForegroundColor = "#ffffffff"
		settings = ""
	}
	
	var id: ID
	var createdTS: Date
	var name: String
	var icon: String
	var iconBackgroundColor: Storage_General.ColorRef
	var iconForegroundColor: Storage_General.ColorRef
	var settings: String
	
	static func create(_ user: User) -> Storage_User {
		let ret = Storage_User()
		
		ret.id = String(describing: user.objectID)
		ret.createdTS = user.created ?? ret.createdTS
		ret.name = user.name ?? ret.name
		ret.icon = user.icon?.base64EncodedString() ?? ret.icon
		ret.iconBackgroundColor = user.iconBackgroundColor ?? ret.iconBackgroundColor
		ret.iconForegroundColor = user.iconForegroundColor ?? ret.iconForegroundColor
		ret.settings = user.settings ?? ret.settings
		
		return ret
	}
}

class Storage_Ticket: Codable {
	typealias ID = String
	
	init() {
		id = ""
		acceptanceCriteria = ""
		brief = ""
		createdTS = .now
		createdByUser = ""
		name = ""
		priority = 0
		lane = ""
		children = []
		comments = []
		tags = []
	}

	var id: ID
	var acceptanceCriteria: String
	var brief: String
	var createdTS: Date
	var createdByUser: Storage_User.ID
	var name: String
	var priority: Int
	var lane: Storage_Lane.ID
	var children: [Storage_Ticket]
	var comments: [Storage_Comment]
	var tags: [Storage_Tag.ID]
	
	static func create(_ ticket: Ticket) -> Storage_Ticket {
		let ret = Storage_Ticket()
		
		ret.id = String(describing: ticket.objectID)
		ret.acceptanceCriteria = ticket.acceptanceCriteria ?? ret.acceptanceCriteria
		ret.brief = ticket.brief ?? ret.brief
		ret.createdTS = ticket.created ?? ret.createdTS
		if let user = ticket.createdBy {
			ret.createdByUser = String(describing: user.objectID)
		}
		ret.name = ticket.name ?? ret.name
		ret.priority = Int(ticket.priority)
		if let lane = ticket.currentLane {
			ret.lane = String(describing: lane.objectID)
		}
		ticket.childTickets?.allObjects.forEach {ret.children.append(Storage_Ticket.create($0 as! Ticket))}
		ticket.comments?.allObjects.forEach {ret.comments.append(Storage_Comment.create($0 as! Comment))}
		ticket.tag?.allObjects.forEach {ret.tags.append(String(describing: ($0 as! TagPool).objectID))}
		return ret
	}
}

class Storage_Tag: Codable {
	typealias ID = String
	
	init() {
		id = ""
		color = "#00000000"
		name = ""
	}
	
	var id: ID
	var color: Storage_General.ColorRef
	var name: String
	
	static func create(_ tag: TagPool) -> Storage_Tag {
		let ret = Storage_Tag()
		ret.id = String(describing: tag.objectID)
		ret.name = tag.name ?? ret.name
		ret.color = tag.colorHex ?? ret.color
		return ret
	}
}

class Storage_Lane: Codable {
	typealias ID = String
	
	init() {
		id = ""
		name = ""
		order = 0
		visible = false
	}
	
	var id: ID
	var name: String
	var order: Int
	var visible: Bool
	
	static func create(_ lane: Lane) -> Storage_Lane {
		let ret = Storage_Lane()
		ret.id = String(describing: lane.objectID)
		ret.name = lane.name ?? ret.name
		ret.order = Int(lane.order)
		ret.visible = lane.visible
		return ret
	}
}

class Storage_Comment: Codable {
	
	init() {
		createdTS = .now
		createdByUser = ""
		removed = false
		text = ""
		removedTS = nil
		removedByUser = ""
		replies = []
	}
	
	var createdTS: Date
	var createdByUser: Storage_User.ID
	var removed: Bool
	var text: String
	var removedTS: Date?
	var removedByUser: Storage_User.ID
	var replies: [Storage_Comment]
	
	static func create(_ comment: Comment) -> Storage_Comment {
		let ret = Storage_Comment()
		ret.createdTS = comment.createdTS
		if let user = comment.author {
			ret.createdByUser = String(describing: user.objectID)
		}
		ret.removed = comment.removed
		ret.removedTS = comment.whenRemoved
		if let user = comment.removedBy {
			ret.removedByUser = String(describing: user.objectID)
		}
		comment.replies?.allObjects.forEach {ret.replies.append(Storage_Comment.create($0 as! Comment))}
		return ret
	}
}
