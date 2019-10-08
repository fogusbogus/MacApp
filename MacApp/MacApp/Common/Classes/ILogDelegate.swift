//
//  ILogDelegate.swift
//  Common
//
//  Created by Matt Hogg on 07/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation

protocol ILogDelegate {
	func logPassThru(type: String, message: String, preformatted: String)
	func getLogOutputPath() -> String
	func getMaxLogLineWidth() -> Int
	func getIDForFilename() -> String
}
