//
//  InterfaceController.swift
//  TwingeBPM WatchKit Extension
//
//  Created by Matt Hogg on 16/04/2020.
//  Copyright © 2020 Matthew Hogg. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class InterfaceController: WKInterfaceController {

	private var _currentBPM = -1
	
	public var BPM : Int {
		get {
			return _currentBPM
		}
		set {
			_currentBPM = newValue
			if _currentBPM < 0 {
				heart.setTintColor(UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.5))
				lblBPM.setTextColor(.gray)
				lblBPM.setText("-")
			}
			else {
				heart.setTintColor(.red)
				lblBPM.setTextColor(.white)
				lblBPM.setText("\(_currentBPM)")
			}
		}
	}
	
	@IBAction func dismissClick() {
		self.dismiss()
	}
	@IBOutlet weak var btnDismiss: WKInterfaceButton!
	@IBOutlet weak var lblBPM: WKInterfaceLabel!
	@IBAction func selected(_ sender: Any) {
	}
	@IBOutlet weak var heartTap: WKTapGestureRecognizer!
	@IBOutlet weak var heart: WKInterfaceImage!
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
	
	private var intervalTimer : Timer? = nil
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		intervalTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(timerDidEnd), userInfo: nil, repeats: true)
		
		setupTimer()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
		if intervalTimer!.isValid {
			intervalTimer?.invalidate()
		}
		intervalTimer = nil
    }
	
	private var pulse : Bool = false
	
	@objc func timerDidEnd(timer:Timer){
		pulse = !pulse
		if pulse {
			heart.setTintColor(.red)
		}
		else {
			heart.setTintColor(UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.5))
		}
	}

	/* Let's animate the heart */
	internal var _timer : Timer? = nil
	
	private var _counter = 0, _counterResetValue = -32
	
	internal func setupTimer() {
		guard _timer == nil else {
			return
		}
		
		_timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (t) in
			self._counter += 1
			var multiplier = 0
			switch self._counter {
			case 0, 8:
				multiplier = 1
			case 1, 7:
				multiplier = 2
			case 2, 6:
				multiplier = 3
			case 3, 5:
				multiplier = 4
			case 4:
				multiplier = 5
			default:
				if self._counter > 0 {
					self._counter = self._counterResetValue
				}
			}
			
			self.heart.setRelativeWidth(1.0, withAdjustment: CGFloat(-4 * multiplier))
		})
		
//		_timer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.doAnimation), userInfo: nil, repeats: true)
	}
	
	@objc func doAnimation() {
		_counter += 1
		var multiplier = 0
		switch _counter {
		case 0, 8:
			multiplier = 1
		case 1, 7:
			multiplier = 2
		case 2, 6:
			multiplier = 3
		case 3, 5:
			multiplier = 4
		case 4:
			multiplier = 5
		default:
			if _counter > 0 {
				_counter = _counterResetValue
			}
		}
		
		heart.setRelativeWidth(1.0, withAdjustment: CGFloat(-4 * multiplier))
	}
}

