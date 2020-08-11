//
//  ViewController.swift
//  NameUploader
//
//  Created by Matt Hogg on 07/08/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Cocoa
import CloudKit
import UsefulExtensions

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		ViewController.populateDBWithForenames()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	public static var _db = CKContainer(identifier: "iCloud.com.fogusbogus.CloudKitStuff.MacApp").database(with: .private)

	static func populateDBWithForenames() {
		
//		var _logFileURL : URL?
//		let dir: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).last! as URL
//		_logFileURL = dir.appendingPathComponent("names.csv")
//
//
//		//Uploading to the iCloud
//
//		//db.open(path: "names.sqlite", openCurrent: false)
//
//		var content = ""
//		do {
//			content = try String.init(contentsOfFile: _logFileURL!.path)
//		}
//		catch {}
//		let allLines = content.split(separator: "\n")
//		var coll : [(String, String)] = []
//		for line in allLines {
//			let items = String(line).trim().getPieces()
//			if items.count > 3 {
//				let name = items.get(1, "")
//				let sex = items.get(3, "")
//				if sex.implies("boy", "girl") {
//					let gender = sex.implies("boy") ? "M" : "F"
//					coll.append((name, gender))
//				}
//				print("\(name), \(sex)")
//			}
//		}
		
		//We now have a collection of names, etc.

		//Our structure in the cloud is name, forename, surname, gender
		//e.g. Jody, T, F, MF
		//Jackson, T, T, M
		
		let pred = NSPredicate(value: true) // NSPredicate(format: "Forename = %@", "T")
		let query = CKQuery(recordType: "Names", predicate: pred)
		
		var toDelete : [CKRecord.ID] = []
		do {
			var queryOperation = createQuery(cursor: nil, query: query)
			queryOperation?.resultsLimit = 400
			
			
			queryOperation?.recordFetchedBlock = { (rec) in
				toDelete.append(rec.recordID)
			}
			
			queryOperation?.queryCompletionBlock = { (cursor, err) in
				
				if cursor != nil {
					print("\(toDelete.count) records counted...fetch more records, please!")
					let newOp = createQuery(cursor: cursor!, query: nil)
					newOp?.recordFetchedBlock = queryOperation?.recordFetchedBlock
					newOp?.queryCompletionBlock = queryOperation?.queryCompletionBlock
					self._db.add(newOp!)
				} else {
					print("cursor is nil")
					let batch = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: toDelete)
					batch.modifyRecordsCompletionBlock = { records, recordIDs, error in
						if let error = error {
							print(error)
						}
						else {
							print("\(toDelete.count) records deleted")
						}
					}
					_db.add(batch)

				}
			}
			_db.add(queryOperation!)
		}
		
		

		
//
//		_db.perform(query, inZoneWith: CKRecordZone.default().zoneID) { (records, err) in
//			if let records = records {
//				records.forEach { (rec) in
//					let f = rec.get("gender", "").impliesContains("F")
//					let m = rec.get("gender", "").impliesContains("M")
//					let name = rec.get("name", "")
//					if f {
//						coll.removeAll { (kv: (String, String)) -> Bool in
//							return name.implies(kv.0) && kv.1.impliesContains("F")
//						}
//					}
//					if m {
//						coll.removeAll { (kv: (String, String)) -> Bool in
//							return name.implies(kv.0) && kv.1.impliesContains("M")
//						}
//					}
//				}
//				//Now we have the collection items that aren't in the iCloud database
//				var count = coll.count
//				var recordsToWrite: [CKRecord] = []
//
//				recordsToWrite.append(contentsOf: coll.map { (kv) -> CKRecord in
//					let (name, gender) = kv
//					let recSave = CKRecord(recordType: "Names")
//					recSave.setValue("T", forKey: "forename")
//					recSave.setValue("F", forKey: "surname")
//					recSave.setValue(name, forKey: "name")
//					recSave.setValue(gender, forKey: "gender")
//					return recSave
//				})
//
//				var batches = recordsToWrite.splice(maxItems: 400)
//
//				batches.forEach { (batchItems) in
//					let batch = CKModifyRecordsOperation(recordsToSave: batchItems, recordIDsToDelete: nil)
//					batch.modifyRecordsCompletionBlock = { records, recordIDs, error in
//						if let error = error {
//							print(error)
//						}
//						else {
//							print("\(records?.count) records written")
//						}
//					}
//					_db.add(batch)
//				}
////				coll.forEach { (kv) in
////					let (name, gender) = kv
////					let recSave = CKRecord(recordType: "Names")
////					recSave.setValue("T", forKey: "forename")
////					recSave.setValue("F", forKey: "surname")
////					recSave.setValue(name, forKey: "name")
////					recSave.setValue(gender, forKey: "gender")
////					_db.save(recSave) { (rec, err) in
////						if let err = err {
////							print("Error: \(err)")
////						}
////						if let rec = rec {
////							print("\(rec.get("name", "")) saved")
////						}
////						count -= 1
////					}
////				}
////				while count > 0 {
////
////				}
//			}
//		}
//
		
//
//		let rec = CKRecord(recordType: )
//		let qy = CKQuery(recordType: , predicate: <#T##NSPredicate#>)
	}
	
	private var _recordFetchedBlock: (CKRecord?) -> Void?
	
	func completionBlock(cursor: CKQueryOperation.Cursor?, err: Error?) {
		
		if cursor != nil {
			print("\(toDelete.count) records counted...fetch more records, please!")
			let newOp = createQuery(cursor: cursor!, query: nil)
			newOp?.recordFetchedBlock = _recordFetchedBlock
			newOp?.queryCompletionBlock = { [weak self] (cursor, err) in
				if cursor != nil {
					self._db.add(completionBlock(cursor: cursor, err: nil))
				}
			}
			self._db.add(newOp!)
		} else {
			print("cursor is nil")
			let batch = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: toDelete)
			batch.modifyRecordsCompletionBlock = { records, recordIDs, error in
				if let error = error {
					print(error)
				}
				else {
					print("\(toDelete.count) records deleted")
				}
			}
			_db.add(batch)
			
		})
	}
	
	static func createQuery(cursor: CKQueryOperation.Cursor? = nil, query: CKQuery? = nil) -> CKQueryOperation? {
		var queryOperation : CKQueryOperation?
			
		if cursor != nil {
			queryOperation = CKQueryOperation(cursor: cursor!)
		}
		else {
			if query != nil {
				queryOperation = CKQueryOperation(query: query!)
			}
		}
		
		return queryOperation
	}

}

extension CKRecord {
	func get<T>(_ name: String, _ defaultValue: T) -> T {
		return self.value(forKey: name) as? T ?? defaultValue
	}
}

extension Array {
	func splice(maxItems: Int) -> [Self] {
		var ret : [Self] = []
		
		self.forEach { (el) in
			if ret.last?.count ?? maxItems >= maxItems {
				ret.append([])
			}
			ret[ret.count - 1].append(el)
		}
		return ret
	}
}
