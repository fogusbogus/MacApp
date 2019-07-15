//
//  ImageRepo.swift
//  MacApp
//
//  Created by Matt Hogg on 09/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import Cocoa

internal class ImageRepo {
	static let shared = ImageRepo()
	
	private init() {
	}
	
	private var _images : [String:NSImage] = [:]
	
	subscript(id: String) -> NSImage? {
		get {
			let img = _images.first { (key: String, value: NSImage) -> Bool in
				return key.implies(id)
			}
			if img != nil {
				return img?.value
			}
			let newImage = NSImage(named: id) ?? NSImage(byReferencingFile: id)
			if newImage != nil {
				_images[id] = newImage!
			}
			return newImage
		}
	}

}
