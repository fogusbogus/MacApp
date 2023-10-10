//
//  Persistence.swift
//  SimpleTODO
//
//  Created by Matt Hogg on 22/07/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	func DeleteAllComments() {
		Log.process("PC::DeleteAllComments") {
			///Delete all comments
			let comments = Comment.getAll()
			comments.forEach {$0.managedObjectContext?.delete($0)}
			try? PersistenceController.shared.container.viewContext.save()
		}
	}
	
	func seed() {
		Log.process("PC::seed()") {
			Lane.seed()
			
			Log.process("Write out settings to settings.json") {
				let filename = getDocumentsDirectory().appendingPathComponent("settings.json")
				do {
					let settings = try JSONEncoder().encode(Settings())
					let data = String(data: settings, encoding: .utf8)!
					try data.write(to: filename, atomically: true, encoding: .utf8)
				}
				catch  {
					Log.error(error)
					//print(error)
				}
			}
			//DeleteAllComments()
			//		let settings = Settings()
			//		let enc = JSONEncoder()
			//		if let data = try? enc.encode(settings) {
			//			if let json = String(data: data, encoding: .utf8) {
			//				print(json)
			//				User.assert(withName: "admin") { user in
			//					user.user.settings = json
			//					try? user.user.managedObjectContext?.save()
			//				}
			//			}
			//		}
			
		}

	}

    let container: NSPersistentCloudKitContainer
	
	//let logHandler = LogHandler()

    init(inMemory: Bool = false) {
		Log.compactLogMessageHandler = Log.compactLogMessageHandler ?? MyLogHandler()
		container = NSPersistentCloudKitContainer(name: "SimpleTODO")
		Log.process("PC::init()") {
			Log.paramList(["inMemory":inMemory])
			if inMemory {
				container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
			}
			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					// Replace this implementation with code to handle the error appropriately.
					// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			container.viewContext.automaticallyMergesChangesFromParent = true
		}
    }
}
