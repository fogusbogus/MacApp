//
//  TreeItem.swift
//  MacApp
//
//  Created by Matt Hogg on 16/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class TreeItem: NSView {

	@IBOutlet weak var cvIndent: NSView!
	@IBOutlet weak var btnBloom: NSButton!
	@IBOutlet weak var cvContent: NSView!
	@IBOutlet weak var lblText: NSTextField!
	
	//TODO: Font changes to this class need to update the label
	var font: NSFont? {
		get {
			return lblText.font
		}
		set {
			lblText.font = newValue
			setNeedsDisplay(bounds)
		}
	}
	
	//TODO: Formatting for the label need to be exposed
	
	var Text : String {
		get {
			return lblText?.stringValue ?? ""
		}
		set {
			lblText?.stringValue = newValue
			setNeedsDisplay(bounds)
		}
	}
	
	var isExpanded : Bool {
		get {
			if let b = btnBloom {
				return b.state == .on
			}
			return false
		}
		set {
			btnBloom?.state = newValue ? .on : .off
		}
	}
	
	var WidthPerIndent = 24
	
	var Level : Int {
		get {
			return Int(cvIndent?.frame.width ?? 0.0 / CGFloat(WidthPerIndent));
		}
		set {
			let newRect = cvIndent?.frame.newSize(width: CGFloat(WidthPerIndent * newValue), height: CGFloat(cvIndent?.frame.height ?? CGFloat(Double(WidthPerIndent))))
			cvIndent?.frame = newRect!
			setNeedsDisplay(newRect!)
		}
	}
	
	override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
		
    }
    
}

extension NSRect {
	func newSize(width: CGFloat, height: CGFloat) -> NSRect {
		return NSRect(origin: self.origin, size: CGSize(width: width, height: height))
	}
}
