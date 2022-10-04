//
//  main.swift
//  Conway
//
//  Created by Matt Hogg on 29/09/2022.
//

import Foundation

let gliders = [
	[[1,0,0],
	 [0,1,1],
	 [1,1,0]],
	[[0,1,0],
	 [0,0,1],
	 [1,1,1]]
]

gliders.forEach { cells in
	Conway.getGeneration(gliders.first!, generations: 100) { cells in
		Conway.printCells(cells, blank: " ", filled: "*")
	}
}


