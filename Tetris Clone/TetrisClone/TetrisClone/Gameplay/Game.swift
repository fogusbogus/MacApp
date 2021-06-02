//
//  Game.swift
//  TetrisClone
//
//  Created by Matt Hogg on 20/02/2021.
//

import SwiftUI

class Game : ObservableObject {
	
	typealias Grid = [[Color]]
	
	//MARK - Scoring
	private var score = 0
	
	private var highScore = 0
	
	
	/// Our score with leading zeros
	var displayScore : String {
		get {
			return String(format: "%08d", score)
		}
	}
	
	/// Our highscore with leading zeros
	var displayHighScore : String {
		get {
			return String(format: "%08d", highScore)
		}
	}
	
	//MARK - Grid
	var rowCount = 23, colCount = 10
	var grid : Grid
	
	//MARK - UI updating
	@Published var update : Bool = false
	
	
	/// We can provide a future list of shapes so our UI can show them
	private var _nextShapes : [Tetromino] = []
	
	/// Our tetromino shapes. FIFO and we keep the array a consistent amount of shapes.
	var nextShapes : [Tetromino] {
		get {
			
			// We need 5 shapes in our array - this is the maximum we will return
			while _nextShapes.count < 5 {
				
				//Create a random tetromino shape - we add to the end but remove from the front
				_nextShapes.append(Tetromino(x: colCount / 2))
			}
			return _nextShapes
		}
	}
	
	/// Is our game over?
	var gameOver: Bool = false {
		didSet {
			update.toggle()
		}
	}
	
	/// What is the current shape we are moving down the grid?
	private var currentShape: Tetromino? = nil
	
	/// We use a standard timer but we might want to increase or decrease when a shape is to drop. By calling and decrementing we can force a downward move immediately just by forcing the decrement value to reset
	func runTimer() {
		if !gameOver {
			timeToNextDrop -= 1
		}
	}
	
	/// Our timer gets called very frequently. To make sure we can move around and rotate without delay to the UI, we use a decrement (timeToNextDrop) which we can force a reset but will be timely for the drop speed
	private var timeToNextDrop : Int {
		didSet {
			if timeToNextDrop < 0 {
				timeToNextDrop = 32
				moveShapeDown()
				killFullRows()
			}
		}
	}
	var fixedTimeToNextDrop = 32
	
	/// Do the drop (but only if our decrementer has reached the reset point)
	private func dropShape() {
		timeToNextDrop -= 1
	}
	
	/// We want our drop to happen immediately
	func forceDropShape() {
		
		//Reset the decrementer
		timeToNextDrop = -1
	}
	
	/// Full rows need to be removed from the grid. This will shift the other rows down.
	private func killFullRows() {
		
		// Do until no more rows to remove
		while true {
			// A full row is defined by no blank spaces on the row
			if let index = grid.firstIndex(where: { columns -> Bool in
				return columns.allSatisfy { (color) -> Bool in
					return color != Color(UIColor.systemBackground)
				}
			}) {
				// Killing the row and shifting is a really simple process with our array. We simply remove the row and insert a blank at the beginning to 'shift it down'.
				
				grid.remove(at: index)
				grid.insert(Array(repeating: Color(UIColor.systemBackground), count: colCount), at: 0)
				score += colCount * 10
			} else {
				return
			}
		}
	}
	
	/// Restart the game but updating the highscore if need be
	func restart() {
		// Create a new grid, force the next drop and save the highscore
		grid = Array(repeating: Array(repeating: Color(UIColor.systemBackground), count: colCount), count: rowCount)
		timeToNextDrop = -1
		if score > highScore {
			highScore = score
		}
		score = 0
		gameOver = false
		
		// We want some fresh tetromino shapes. By clearing the array, it will get reset when accessed via the accessor property.
		_nextShapes.removeAll()
	}
	
	/// Get the current (or next if none available) tetromino shape
	/// - Returns: Tetromino shape type
	@discardableResult
	private func getCurrentShape() -> Tetromino? {
		
		// If we already have a shape available that hasn't landed then use that one
		guard currentShape == nil else {
			return currentShape
		}

		// Get our next shape. We need to remove from the array so another gets created on the end of the array.
		if nextShapes.count > 0 {
			
			//We have to remove from the root variable
			currentShape = _nextShapes.removeFirst()
		}
		
		// If it already breaches rules then GAME OVER. We've obviously come to the top of the grid
		if !isLegalMove(shape: currentShape!) {
			gameOver = true
			currentShape = nil
		}
		return currentShape
	}
	
	//MARK - Movement
	
	/// Force the shape downwards
	func moveShapeDown() {
		guard !gameOver else {
			return
		}
		
		// Get the current shape
		getCurrentShape()
		
		// We may have already failed in our quest if the current shape is out of bounds (i.e. grid filled up)
		if gameOver {
			return
		}

		// Attempt to move the shape down. If there are conflcts it's not possible to move it down and it needs to be permanently added to the grid.
		currentShape?.y += 1
		if !isLegalMove(shape: currentShape!) {
			currentShape?.y -= 1
			
			//Turn it into part of the grid
			saveToGrid(shape: currentShape!)
			currentShape = nil
			return
		}
		
		// 5 points for each line of a drop
		score += 5
		
		// UI update
		update.toggle()
	}
	
	
	/// Rotate the shape by 90 degrees
	func rotateLeft() {
		
		guard !gameOver else {
			return
		}
		
		// Get the current shape, keeping in mind we might force a 'game over'
		getCurrentShape()
		
		if gameOver {
			return
		}
		
		// Get the new rotation, try it and if there are conflicts on the grid we cannot allow the rotation
		let oldRotation = currentShape!.rotation
		switch currentShape?.rotation {
			case ._0:
				currentShape?.rotation = ._90
				break
			case ._90:
				currentShape?.rotation = ._180
				break
			case ._180:
				currentShape?.rotation = ._270
				break
			default:
				currentShape?.rotation = ._0
				break
		}
		if !isLegalMove(shape: currentShape!) {
			currentShape?.rotation = oldRotation
			return
		}
		update.toggle()
	}
	
	/// Rotate the shape by -90 degrees
	func rotateRight() {
		guard !gameOver else {
			return
		}
		
		// Get the current shape, keeping in mind we might force a 'game over'
		getCurrentShape()
		
		if gameOver {
			return
		}
		
		// Get the new rotation, try it and if there are conflicts on the grid we cannot allow the rotation
		let oldRotation = currentShape!.rotation
		switch currentShape?.rotation {
			case ._0:
				currentShape?.rotation = ._270
				break
			case ._90:
				currentShape?.rotation = ._0
				break
			case ._180:
				currentShape?.rotation = ._90
				break
			default:
				currentShape?.rotation = ._180
				break
		}
		if !isLegalMove(shape: currentShape!) {
			currentShape?.rotation = oldRotation
			return
		}
		update.toggle()
	}
	
	/// Move the shape to the left
	func moveLeft() {
		guard !gameOver else {
			return
		}
		
		// Get the current shape, keeping in mind we might force a 'game over'
		getCurrentShape()
		
		if gameOver {
			return
		}
		
		// Move the shape and if there are conflicts on the grid, we cannot move it
		let oldX = currentShape!.x
		currentShape!.x -= 1
		if !isLegalMove(shape: currentShape!) {
			currentShape!.x = oldX
			return
		}
		update.toggle()
	}
	
	func moveRight() {
		guard !gameOver else {
			return
		}
		
		// Get the current shape, keeping in mind we might force a 'game over'
		getCurrentShape()
		
		if gameOver {
			return
		}
		
		// Move the shape and if there are conflicts on the grid, we cannot move it
		let oldX = currentShape!.x
		currentShape!.x += 1
		if !isLegalMove(shape: currentShape!) {
			currentShape!.x = oldX
			return
		}
		update.toggle()
	}
	
	/// For UI purposes we need to return the grid with the shape on it
	/// - Returns: Grid type
	func updatedGrid() -> Grid {
		return projectShapeOntoGrid(shape: currentShape)
	}
	
	
	/// Initializer
	/// - Parameters:
	///   - rows: How many rows in the grid
	///   - cols: How many columns in the grid
	init(rows: Int = 23, cols: Int = 10) {
		self.rowCount = rows
		self.colCount = cols
		grid = Array(repeating: Array(repeating: Color(UIColor.systemBackground), count: cols), count: rows)
		timeToNextDrop = -1
	}
	
	
	/// The grid is held in the class instance, but we need to return the grid and current shape
	/// - Parameter shape: The shape to project onto the grid
	/// - Returns: The grid data with the shape projected onto it (copy only)
	private func projectShapeOntoGrid(shape: Tetromino?) -> Grid {
		var ret = self.grid
		if let shape = shape {
			let points = shape.type.shapePoints(rotation: shape.rotation).map { (xy) -> (Int,Int) in
				return (xy.0+shape.x, xy.1+shape.y)
			}
			points.forEach { (xy) in
				ret[xy.1][xy.0] = shape.color
			}
		}
		return ret
	}
	
	
	/// We need to make the shape a permanent part of the grid data, so other shapes can land on it
	/// - Parameter shape: The tetromino we are saving to the grid
	private func saveToGrid(shape: Tetromino) {
		let points = shape.type.shapePoints(rotation: shape.rotation).map { (xy) -> (Int,Int) in
			return (xy.0+shape.x, xy.1+shape.y)
		}
		points.forEach { (xy) in
			grid[xy.1][xy.0] = shape.color
		}
	}
	
	/// Use projection of the shape onto the grid data to see if it lands on anything
	/// - Parameter shape: Tetromino shape to project
	/// - Returns: true if the shape projects clearly onto the grid data, false if there is data already there
	private func isLegalMove(shape: Tetromino) -> Bool {
		let points = shape.type.shapePoints(rotation: shape.rotation).map { (xy) -> (Int,Int) in
			return (xy.0+shape.x, xy.1+shape.y)
		}
		
		//Outside the boundary check
		if points.filter ({ (xy) -> Bool in
			return xy.0 < 0 || xy.0 >= colCount || xy.1 < 0 || xy.1 >= rowCount
		}).count > 0 {
			return false
		}
		
		//Projection must be to a clear space
		if points.filter({ (xy) -> Bool in
			return grid[xy.1][xy.0] != Color(UIColor.systemBackground)
		}).count > 0 {
			return false
		}
		
		return true
	}
	
	
}




