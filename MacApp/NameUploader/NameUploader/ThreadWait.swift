//
//  ThreadWait.swift
//  NameUploader
//
//  Created by Matt Hogg on 21/08/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import Foundation

class Thread {
	
	static func wait(execute: () -> Void) {
		DispatchQueue(label: UUID().uuidString).sync(execute: execute)
	}
}
