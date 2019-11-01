//
//  main.swift
//  clBalderdash
//
//  Created by Matt Hogg on 17/10/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import Foundation
import Physics

func rnd(_ lower : Int, _ higher : Int) -> Int {

	return Int.random(in: lower...higher)
}

let win = winsize()

let w = 120
let h = 27

//Clear the screen
print("\u{001B}[2J")

let map = BDMap()

map.AddObject(obj: BDCaver(x: 1, y: 1))

var count = rnd(300, 450)

for _ in 1..<count {
	let sprite = BDSprite(x: rnd(1, w - 2), y: rnd(1, h - 2))
	map.AddObject(obj: sprite)
}

count = rnd(300, 500)

for _ in 1..<count {
	//Let's add a boulder
	var x = rnd(0, w - 2) + 1
	var y = rnd(0, h - 2) + 1
	while map.IsLocationTaken(x: x, y: y) {
		x = rnd(0, w - 2) + 1
		y = rnd(0, h - 2) + 1
	}
	map.AddObject(obj: BDBoulder(x: x, y: y))
}

count = rnd(300, 530)

for _ in 1..<count {
	//Let's add a diamond
	var x = rnd(0, w - 2) + 1
	var y = rnd(0, h - 2) + 1
	while map.IsLocationTaken(x: x, y: y) {
		x = rnd(0, w - 2) + 1
		y = rnd(0, h - 2) + 1
	}
	map.AddObject(obj: BDDiamond(x: x, y: y))
}

count = rnd(50, 80)

for _ in 1..<count {
	//Let's add a wall
	var x = rnd(0, w - 2) + 1
	var y = rnd(0, h - 2) + 1
	while map.IsLocationTaken(x: x, y: y) {
		x = rnd(0, w - 2) + 1
		y = rnd(0, h - 2) + 1
	}
	map.AddObject(obj: BDWall(x: x, y: y))
}

count = rnd(200, 400)

for _ in 1..<count {
	//Let's add some grass
	var x = rnd(0, w - 2) + 1
	var y = rnd(0, h - 2) + 1
	while map.IsLocationTaken(x: x, y: y) {
		x = rnd(0, w - 2) + 1
		y = rnd(0, h - 2) + 1
	}
	map.AddObject(obj: BDGrass(x: x, y: y))
}

//Outside wall
for i in 0..<w - 1 {
	map.AddObject(obj: BDWall(x: i, y: 0))
	map.AddObject(obj: BDWall(x: i, y: h - 1))
}
for i in 0..<h {
	map.AddObject(obj: BDWall(x: 0, y: i))
	map.AddObject(obj: BDWall(x: w - 1, y: i))
}

var sb = ""
let sLine = String(repeating: " ", count: w)
while true {
	map.Animate()
	sb = ""
	for y in 0..<h {
		let objs = map.GetObjectsAtYPosition(y: y)
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
				line[grass.Location.x] = "🌱"
			}
			if let boulder = obj as? BDBoulder {
				line[boulder.Location.x] = "🥔"
			}
			if let diamond = obj as? BDDiamond {
				line[diamond.Location.x] = "💎"
			}
			if let sprite = obj as? BDSprite {
				line[sprite.Location.x] = "👻"
			}
		}
		sb.append(String(line))
		sb.append("\r\n")
	}
	print("\u{1B}[0;0H")
	print(sb)
}
