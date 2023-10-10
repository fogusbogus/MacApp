//
//  GridSquare.swift
//  Mine
//
//  Created by Matt Hogg on 01/06/2021.
//

import Foundation
import UIKit
import AVFoundation

/// A cell can contain a bomb. It can also be flagged which would make the bomb safe. It can also flag if empty which would be an incorrect placement. A numerical value that contains the number of bombs directly surrounding it can be generated.
class Cell {
	
	/// A cell is surrounded by other cells. By keeping a tab of which ones we can recursively clear a set of cells without a complex algorithm. It also allows us to clear multi-cells in one swoop.
	public var linkedCells : [Cell] = []
	/// Is this a bomb cell?
	public var isBomb = false
	/// Is this cell still tiled?
	public var isRevealed = false
	/// Is this cell flagged?
	public var isMarked = false
	/// Which of our images to use to represent the cell
	public var image : String {
		get {
			if !isRevealed {
				return isMarked ? "Flag" : "Unrevealed"
			}
			if isMarked {
				return "Flag"
			}
			if isBomb {
				return "Bomb"
			}
			let count = linkedCells.filter { gs in
				return gs.isBomb
			}.count
			return count == 0 ? "Blank" : "\(count)"
		}
	}
	
	
	/// The cell is blank if a) no bomb inside b) is not flagged c) doesn't infer a number
	/// - Returns: True/false
	func isBlank() -> Bool {
		if isBomb || isMarked {
			return false
		}
		return linkedCells.filter { cell in
			return cell.isBomb
		}.count == 0
	}
	
	/// Reveal the cell
	func reveal() {
		//Cannot reveal an already revealed cell
		if isRevealed {
			return
		}
		isRevealed = true
		
		//Emulate a flood fill by revealing cells around this one. But only if this cell is blank.
		if isBlank() {
			linkedCells.forEach { cell in
				cell.reveal()
			}
		}
	}
	
	/// Adds an existing linked cell
	/// - Parameter item: A cell or nil
	func appendLinkedCell(_ item: Cell?) {
		if let item = item {
			linkedCells.append(item)
		}
	}
}
