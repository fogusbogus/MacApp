//
//  URL.swift
//  Common
//
//  Created by Matt Hogg on 24/11/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

public class EasyURL {
	public static func document(_ filename: String) -> URL {
		let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
		return dir.appendingPathComponent(filename)
	}
	
	public static func download(_ filename: String) -> URL {
		let dir: URL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).last! as URL
		return dir.appendingPathComponent(filename)
	}
	
}
