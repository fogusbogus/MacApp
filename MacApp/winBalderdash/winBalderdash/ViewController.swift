//
//  ViewController.swift
//  winBalderdash
//
//  Created by Matt Hogg on 18/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Cocoa
import Physics

class ViewController: NSViewController {

	private var _timer : Timer?
	private var _map = BDMap()
	
	@objc private func Tick() {
		_map.Animate()
		
		var sb = ""
		let sLine = String(repeating: " ", count: 132)
		for y in 0..<27 {
			let objs = _map.GetObjectsAtYPosition(y: y)
			var line = sLine.map { $0 }
			for obj in objs {
				if let caver = obj as? BDCaver {
					if caver.IsDead {
						line[caver.Location.x] = "+"
					}
					else {
						line[caver.Location.x] = "£"
					}
				}
				if let wall = obj as? BDWall {
					line[wall.Location.x] = "█"
				}
				if let grass = obj as? BDGrass {
					line[grass.Location.x] = "`" //"🌱"
				}
				if let boulder = obj as? BDBoulder {
					line[boulder.Location.x] = "O" //"🥔"
				}
				if let diamond = obj as? BDDiamond {
					line[diamond.Location.x] = "." // "💎"
				}
				if let sprite = obj as? BDSprite {
					line[sprite.Location.x] = "*" // "👻"
				}
			}
			sb.append(String(line))
			sb.append("\r\n")
		}
		lblArea.stringValue = sb
	}
	
	@IBOutlet weak var lblArea: NSTextField!
	override func viewDidLoad() {
		super.viewDidLoad()
				
		let w = 120
		let h = 27

		_map.AddObject(obj: BDCaver(x: 1, y: 1))

		var count = rnd(300, 450)

		for _ in 1..<count {
			let sprite = BDSprite(x: rnd(1, w - 2), y: rnd(1, h - 2))
			_map.AddObject(obj: sprite)
		}

		count = rnd(300, 500)

		for _ in 1..<count {
			//Let's add a boulder
			var x = rnd(0, w - 2) + 1
			var y = rnd(0, h - 2) + 1
			while _map.IsLocationTaken(x: x, y: y) {
				x = rnd(0, w - 2) + 1
				y = rnd(0, h - 2) + 1
			}
			_map.AddObject(obj: BDBoulder(x: x, y: y))
		}

		count = rnd(300, 530)

		for _ in 1..<count {
			//Let's add a diamond
			var x = rnd(0, w - 2) + 1
			var y = rnd(0, h - 2) + 1
			while _map.IsLocationTaken(x: x, y: y) {
				x = rnd(0, w - 2) + 1
				y = rnd(0, h - 2) + 1
			}
			_map.AddObject(obj: BDDiamond(x: x, y: y))
		}

		count = rnd(50, 80)

		for _ in 1..<count {
			//Let's add a wall
			var x = rnd(0, w - 2) + 1
			var y = rnd(0, h - 2) + 1
			while _map.IsLocationTaken(x: x, y: y) {
				x = rnd(0, w - 2) + 1
				y = rnd(0, h - 2) + 1
			}
			_map.AddObject(obj: BDWall(x: x, y: y))
		}

		count = rnd(200, 400)

		for _ in 1..<count {
			//Let's add some grass
			var x = rnd(0, w - 2) + 1
			var y = rnd(0, h - 2) + 1
			while _map.IsLocationTaken(x: x, y: y) {
				x = rnd(0, w - 2) + 1
				y = rnd(0, h - 2) + 1
			}
			_map.AddObject(obj: BDGrass(x: x, y: y))
		}

		//Outside wall
		for i in 0..<w - 1 {
			_map.AddObject(obj: BDWall(x: i, y: 0))
			_map.AddObject(obj: BDWall(x: i, y: h - 1))
		}
		for i in 0..<h {
			_map.AddObject(obj: BDWall(x: 0, y: i))
			_map.AddObject(obj: BDWall(x: w - 1, y: i))
		}
		// Do any additional setup after loading the view.
		_timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.025), target: self, selector: (#selector(Tick)), userInfo: nil, repeats: true)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	func rnd(_ lower : Int, _ higher : Int) -> Int {

		return Int.random(in: lower...higher)
	}
}

