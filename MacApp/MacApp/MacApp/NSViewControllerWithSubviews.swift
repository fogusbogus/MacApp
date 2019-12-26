//
//  NSViewControllerWithSubviews.swift
//  MacApp
//
//  Created by Matt Hogg on 25/12/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa

class NSViewControllerWithSubviews: NSViewController, SubviewNotifier, SubviewHandler {
	
	private var _handlers : [SubviewHandler] = []
	
	func subscribe(_ handler: SubviewHandler) {
		_handlers.append(handler)
	}
	
	func notifySubview(view: Any) {
		_handlers.forEach { (handler) in
			handler.notifySubview(view: view)
		}
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		
		//Log.Checkpoint("Segue preparation", "prepare", {
		notifySubview(view: segue.destinationController)
		if let svc = segue.destinationController as? SubviewNotifier {
			svc.subscribe(self)
		}
	}
}
