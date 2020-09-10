//
//  iCloudModifier.swift
//  NameUploader
//
//  Created by Matt Hogg on 21/08/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation
import CloudKit

class iCloudModifier {
	//CKModifyRecordsOperation
	
	func updateOrInsert(database: CKDatabase, records: [CKRecord], afterCollection: (() -> Void)? = nil) {
		
		_db = database
		
		_finished = false
		
		let recs = records.chunked(into: 400)
				
		var count = recs.count
		
		recs.forEach { (coll) in
			let batch = CKModifyRecordsOperation(recordsToSave: coll, recordIDsToDelete: nil)
			batch.modifyRecordsCompletionBlock = { records, recordIDs, error in
				count -= 1
				if let error = error {
					print(error)
				}
				else {
					print("\(records?.count) records updated")
				}
			}
			
			database.add(batch)
		}
		
		while count > 0 {}
		
		_finished = true
		afterCollection?()
	}
	
	func delete(database: CKDatabase, records: [CKRecord.ID], afterCollection: (() -> Void)? = nil) {
		
		_db = database
		
		_finished = false
		
		let recs = records.chunked(into: 400)
		
		var count = recs.count
		
		recs.forEach { (coll) in
			let batch = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: coll)
			batch.modifyRecordsCompletionBlock = { records, recordIDs, error in
				count -= 1
				if let error = error {
					print(error)
				}
				else {
					print("\(recordIDs?.count) records deleted")
				}
			}
			
			database.add(batch)
		}
		
		while count > 0 {}
		
		_finished = true
		afterCollection?()
	}
	
	private var _finished  = false
	private var _db: CKDatabase? = nil
	
	
}

extension Array {
	func chunked(into size: Int) -> [[Element]] {
		return stride(from: 0, to: count, by: size).map {
			Array(self[$0 ..< Swift.min($0 + size, count)])
		}
	}
}
