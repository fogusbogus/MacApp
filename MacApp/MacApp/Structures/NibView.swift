//
//  NibView.swift
//  Common
//
//  Created by Matt Hogg on 06/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

public class NibView: NSView {
	
	/// By default the nibName is the name of this class. However, the class may be representing the xib that has a different name. Override this and return the xib name.
	var nibName : String {
		get {
			return String(describing: type(of: self))
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadViewFromNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadViewFromNib()
	}
	
	private func getNib() -> NSView? {
		print("getNib for '\(nibName)'")
		let mytype = type(of: self)
		let bundle = Bundle(for: mytype)
		
		var topLevelArray: NSArray? = nil
		bundle.loadNibNamed(nibName, owner: self, topLevelObjects: &topLevelArray)
		let views = Array<Any>(topLevelArray!).filter { type(of: $0) == mytype }
		return views.last as? NSView
	}
	
	var view : NSView!
	private func loadViewFromNib() {
		guard let view = getNib() else { return }
		view.frame = bounds
		view.autoresizingMask =  [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
		addSubview(view)
		self.view = view
	}
	
	/// Handle all the non-localizable items in here. Other nib controls may have custom properties
	/// that require localizing, too. So override this and do it in here.
	func localize() {
		
	}
	
	final func locString(_ key: String, _ comment : String = "") -> String {
		return NSLocalizedString(key, comment: comment)
	}
}

