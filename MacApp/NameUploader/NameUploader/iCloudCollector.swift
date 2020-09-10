//
//  iCloudCollector.swift
//  NameUploader
//
//  Created by Matt Hogg on 21/08/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation
import CloudKit

class iCloudCollector {
	func collect(database: CKDatabase, predicate: NSPredicate? = nil, table: String, recordFetched: ((CKRecord) -> Void)?, afterCollection: (() -> Void)? = nil, queryManipulator: ((CKQueryOperation) -> Bool)?) {
		_db = database
		_recordFetched = recordFetched
		_queryManipulator = queryManipulator
		
		_finished = false
		
		let query = CKQuery(recordType: table, predicate: predicate ?? NSPredicate(value:true))
		let queryOperation = CKQueryOperation(query: query)
		_ = queryManipulator?(queryOperation)
		queryOperation.recordFetchedBlock = _recordFetched
		queryOperation.queryCompletionBlock = completionBlock
		_afterCollection = {
			self._finished = true
		}
		database.add(queryOperation)
		while (!_finished) {}
		afterCollection?()
	}
	
	private var _finished  = false
	private var _db: CKDatabase? = nil
	private var _recordFetched: ((CKRecord) -> Void)? = nil
	private var _afterCollection: (() -> Void)? = nil
	private var _queryManipulator: ((CKQueryOperation) -> Bool)? = nil
	
	private func completionBlock(cursor: CKQueryOperation.Cursor?, err: Error?) {
		if cursor != nil {
			let newOp = CKQueryOperation(cursor: cursor!)
			if let qm = _queryManipulator {
				if !qm(newOp) {
					_afterCollection?()
					return
				}
			}
			newOp.recordFetchedBlock = _recordFetched
			newOp.queryCompletionBlock = completionBlock
			self._db!.add(newOp)
		} else {
			_afterCollection?()
		}
	}
}
