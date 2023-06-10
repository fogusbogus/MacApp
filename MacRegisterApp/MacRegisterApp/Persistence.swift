//
//  Persistence.swift
//  MacRegisterApp
//
//  Created by Matt Hogg on 20/05/2023.
//

import CoreData
import MeasuringView

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

    let container: NSPersistentCloudKitContainer
	
	let measuring = MeasuringView()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MacRegister")
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


extension MigrationData {
	func save(context: NSManagedObjectContext? = nil) {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		self.pollingDistricts.forEach { mpd in
			let pd = PollingDistrict(context: context)
			pd.name = mpd.name
			pd.sortName = mpd.name
			mpd.wards.forEach { mwd in
				let wd = Ward(context: context)
				pd.addToWards(wd)
				wd.name = mwd.name
				wd.sortName = mwd.sort ?? mwd.name
				mwd.streets.forEach { mst in
					let st = Street(context: context)
					wd.addToStreets(st)
					st.name = mst.name
					st.sortName = mst.sort ?? mst.name
					st.postCode = mst.postCode
				}
			}
		}
		try? context.save()
	}
}


extension NSSet {
	func mappedObjects<T>() -> [T] {
		return self.allObjects.compactMap {$0 as? T}
	}
}

extension Optional where Wrapped: NSSet {
	func mappedObjects<T>() -> [T] {
		return self?.allObjects.compactMap {$0 as? T} ?? []
	}
}


extension PollingDistrict {
	static func getAll(context: NSManagedObjectContext? = nil) -> [PollingDistrict] {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		let fetch = PollingDistrict.fetchRequest()
		do {
			let res = try context.fetch(fetch)
			return res
		}
		catch {
			
		}
		return []
	}
}

extension Ward {
	static func getAll(context: NSManagedObjectContext? = nil) -> [Ward] {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		let fetch = Ward.fetchRequest()
		do {
			let res = try context.fetch(fetch)
			return res
		}
		catch {
			
		}
		return []
	}
}

extension Street {
	static func getAll(context: NSManagedObjectContext? = nil) -> [Street] {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		let fetch = Street.fetchRequest()
		do {
			let res = try context.fetch(fetch)
			return res
		}
		catch {
			
		}
		return []
	}
}

extension SubStreet {
	static func getAll(context: NSManagedObjectContext? = nil) -> [SubStreet] {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		let fetch = SubStreet.fetchRequest()
		do {
			let res = try context.fetch(fetch)
			return res
		}
		catch {
			
		}
		return []
	}
}

extension Abode {
	static func getAll(context: NSManagedObjectContext? = nil) -> [Abode] {
		let context = context ?? PersistenceController.shared.container.viewContext
		
		let fetch = Abode.fetchRequest()
		do {
			let res = try context.fetch(fetch)
			return res
		}
		catch {
			
		}
		return []
	}
	
	var address: String {
		get {
			var items: [String] = [objectName]
			if let ss = subStreet {
				items.append(ss.objectName)
				if let st = ss.street {
					items.append(st.objectName)
					if let wd = st.ward {
						items.append(wd.objectName)
						if let pd = wd.pollingDistrict {
							items.append(pd.objectName)
						}
					}
				}
			}
			return items.joined(separator: ", ")
		}
	}
}
