//
//  ViewController.swift
//  CloudKitStuff
//
//  Created by Matt Hogg on 18/06/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
	
	private var _db = CKContainer(identifier: "iCloud.com.fogusbogus.CloudKitStuff.testCloud").database(with: .private)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		let pred = NSPredicate(value: true)
		let pred2 = NSPredicate { (rec, items) -> Bool in
			print(items)
			return true
		}
		let q = CKQuery(recordType: "Note", predicate: pred2)
		_db.perform(q, inZoneWith: CKRecordZone.default().zoneID) { [weak self] (records, err) in
			guard let self = self else {return}
			if let recs = records {
				recs.forEach { (rec) in
					print(rec.value(forKey: "content"))
					print(rec.value(forKey: "Date"))
				}
			}
		}
		
//		let data = "This is a test!"
//		let note = CKRecord(recordType: "Note")
//
//		note.setValue(data, forKey: "content")
//		note.setValue(Date(), forKey: "Date")
//
//		_db.save(note) { (rec, err) in
//			guard let rec = rec else {
//				print("\(err)")
//				return
//			}
//			print("\(rec.recordID)")
//		}
	}


}

