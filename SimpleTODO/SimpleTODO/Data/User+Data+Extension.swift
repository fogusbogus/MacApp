//
//  User+Data+Extension.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 23/07/2023.
//

import Foundation

extension User {
	static func `get`(withName: String) -> User? {
		return Log.return {
			let context = PersistenceController.shared.container.viewContext
			let fetch = User.fetchRequest()
			fetch.predicate = NSPredicate(format: "name LIKE %@", withName)
			do {
				return try context.fetch(fetch).first
			}
			catch {
			}
			return nil
		} pre: {
			Log.funcParams("User::get", items: ["withName":withName])
		} post: { user in
			Log.log("<< \(user?.myObjectID ?? "nil")")
		}

	}
	
	static func getAll() -> [User] {
		let context = PersistenceController.shared.container.viewContext
		let fetch = User.fetchRequest()
		do {
			return try context.fetch(fetch)
		}
		catch {
		}
		return []
	}
	
	static func admin() -> User {
		return assert(withName: "admin")
	}
	
	typealias CreateOrUpdatePredicate = (user: User, isNew: Bool)

	
	@discardableResult
	static func assert(withName: String, onCreateOrUpdate: ((CreateOrUpdatePredicate) -> Void)? = nil) -> User {
		return Log.return {
			if let ret = get(withName: withName) {
				onCreateOrUpdate?((user: ret, isNew: false))
				return ret
			}
			
			return Log.return {
				let new = User(context: PersistenceController.shared.container.viewContext)
				new.created = Date.now
				new.name = withName
				onCreateOrUpdate?((user: new, isNew: true))
				return new
			} pre: {
				Log.log("Couldn't find user. Creating a new one.")
			} post: { _ in
				
			}

		} pre: {
			Log.funcParams("User::assert", items: ["withName":withName, "onCreateOrUpdate":(onCreateOrUpdate != nil)])
		} post: { user in
			Log.log("<< \(user.myObjectID)")
		}

	}
	
	func getSettings() -> Settings {
		PersistentSettings.shared.setUserAndSettings(user: name ?? "") {
			if let settings = settings {
				let dec = JSONDecoder()
				do {
					return try dec.decode(Settings.self, from: settings.data(using: .utf8)!)
				}
				catch {}
			}
			return Settings()
		}
		return PersistentSettings.shared.currentSettings
	}
	
	static func userName() -> String {
		let user = NSUserName()
		if user.count == 0 {
			return "Matt"
		}
		return user
	}
	
	static func currentUser(onCreateOrUpdate: ((CreateOrUpdatePredicate) -> Void)? = nil) -> User {
		return assert(withName: userName(), onCreateOrUpdate: onCreateOrUpdate)
	}
	
	func isCurrentUserOrAdmin() -> Bool {
		return User.currentUser().objectID == objectID || User.admin().objectID == objectID
	}
	
	override public func willSave() {
		Log.log("Prepare for saving: \(Self.self) '\(name ?? "")' (\(myObjectID))")
	}		
}

class PersistentSettings {
	static let shared = PersistentSettings()
	
	private(set) var currentUser : String
	private(set) var currentSettings: Settings
	
	private init() {
		currentUser = ""
		currentSettings = Settings()
	}
	
	func setUserAndSettings(user: String, whenDifferent: () -> Settings) {
		if currentUser != user {
			currentUser = user
			currentSettings = whenDifferent()
		}
	}
}