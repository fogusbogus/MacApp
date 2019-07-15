//
//  TreeNodeImage.swift
//  MacApp
//
//  Created by Matt Hogg on 14/07/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

@objc
class TreeNodeImage: NSImageCell {

	private var _nodeImage : NSImage?
	
	@objc dynamic var nodeImage : NSImage? {
		get {
			return _nodeImage
		}
		set {
			_nodeImage = newValue
			image = newValue
		}
	}
}

