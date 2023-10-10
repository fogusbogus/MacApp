//
//  Grid.swift
//  Mine
//
//  Created by Matt Hogg on 29/05/2021.
//

import Foundation
import UIKit
import AVFoundation


class Grid : ObservableObject {
	
	/// How are we revealing our cell/cells
	enum RevealType {
		case single, multi, flag
	}
	
	/// Initializer. Make sure we have some grid data.
	init() {
		let _ = grid
	}
	
	/// Reveal type - default single. The UI reads/writes from/to this and will update the UI accordingly.
	public var revealType : RevealType = .single {
		didSet {
			updateUI()
		}
	}
	
	/// Depending on which reveal type is used, this provides a multiplier for a border (UI).
	/// - Parameter type: A matching reveal type
	/// - Returns: 1 or zero.
	public func revealTypeBorderWidthMultiplier(_ type: RevealType) -> CGFloat {
		if type == revealType {
			return CGFloat(1)
		}
		return CGFloat.zero
	}
	
	
	/// We want to play again, so reset the grid
	func reset() {
		_grid = []
		let _ = grid
		updateUI()
	}
	
	/// Size of the board
	var height = 24, width = 24
	
	/// Each cell is held in its own class. We store the cell in a one-dimensional array but access it here using x and y co-ordinates.
	/// - Parameters:
	///   - x: x position
	///   - y: y position
	/// - Returns: The cell (if it exists and x/y is in range)
	func getCell(_ x: Int, _ y: Int) -> Cell? {
		//Our of range handling
		if x < 0 || x >= width || y < 0 || y >= height {
			return nil
		}
		
		//We assume the grid is set up correctly
		return _grid[y * width + x]
	}
	
	/// Returns a status of whether the game has ended
	/// - Returns: True/false
	func gameEnded() -> Bool {
		let ret = grid.first { cell in
			return cell.isRevealed && cell.isBomb && !cell.isMarked
		} != nil
		if ret {
			stopTimer()
		}
		return ret
	}
	
	/// Returns a status of whether the game has been completed successfully
	/// - Returns: True/false
	func gameComplete() -> Bool {
		//All cells need to be revealed
		let allRevealed = grid.first { cell in
			return !cell.isRevealed
		} == nil
		
		//All bombs need to be flagged
		let allBombsFlagged = grid.first { cell in
			return cell.isBomb && !cell.isMarked
		} == nil
		
		//Only bombs must be flagged
		let flagsOnClearCells = grid.first { cell in
			return !cell.isBomb && cell.isMarked
		} != nil
		if allRevealed && allBombsFlagged && !flagsOnClearCells {
			stopTimer()
			return true
		}
		return false
	}
	
	/// Our collection of cells
	var _grid : [Cell] = []
	
	/// Property Get for the cells - initializes the grid if necessary
	var grid : [Cell] {
		get {
			//Do we need to initialize? (i.e. empty base array)
			if _grid.count == 0 {
				
				//Create the cells
				(0..<height*width).forEach { i in
					_grid.append(Cell())
				}
				
				//Use a two-dimensional pseudo-array for clarity
				(0..<height).forEach { y in
					(0..<width).forEach { x in
						let cell = getCell(x, y)!
						
						//We don't actually need to check, but reliance on the appendLinkedItem function to filter out-of-bounds is slower
						if y > 0 {
							let ym1 = y-1
							cell.appendLinkedCell(getCell(x, ym1))
							cell.appendLinkedCell(getCell(x-1, ym1))
							cell.appendLinkedCell(getCell(x+1, ym1))
							
						}
						if y == y	{
							//Only left and right - we don't include ourselves as a linked cell
							cell.appendLinkedCell(getCell(x-1, y))
							cell.appendLinkedCell(getCell(x+1, y))
						}
						if y < height - 1 {
							let ym1 = y+1
							cell.appendLinkedCell(getCell(x, ym1))
							cell.appendLinkedCell(getCell(x-1, ym1))
							cell.appendLinkedCell(getCell(x+1, ym1))
						}
					}
				}
			}
			return _grid
		}
	}
	
	/// Gets a count of the number of revealed cells
	/// - Returns: Int value
	func countRevealed() -> Int {
		return grid.filter { cell in
			return !cell.isRevealed
		}.count
	}
	
	/// Reveal the cell
	/// - Parameters:
	///   - x: x position
	///   - y: y position
	func reveal(x: Int, y: Int) {
		
		//We cannot reveal anything if the game is ended
		guard !gameEnded() else { return }
		
		//On a first move there are no bombs in the grid. This is to ensure that the first move never hits a bomb (and it is always treated as a singular cell reveal type). So we'll check to see if there are no bombs - if so, populate, if not, reveal the cell(s) in the manner required.
		if grid.filter({ cell in
			return cell.isBomb
		}).count == 0 {
			fillWithBombs(firstMoveX: x, firstMoveY: y, numberOfBombs: 50)
			playSound(Sounds.Single)
			startTimer()
		}
		else {
			
			guard let cell = getCell(x, y) else {
				return
			}
			switch revealType {
				case .flag:
					if !cell.isRevealed {
						cell.isMarked = !cell.isMarked
						playSound(Sounds.Flag)
					}
					break
					
				case .multi:
					cell.reveal()
					let alreadyRevealed = countRevealed()
					cell.linkedCells.forEach { gs in
						gs.reveal()
					}
					if !gameEnded() && countRevealed() != alreadyRevealed {
						playSound(Sounds.Multi)
					}
					break
					
				case .single:
					cell.reveal()
					if !gameEnded() {
						playSound(Sounds.Single)
					}
					break
			}
		}
		if gameEnded() {
			//Reveal all the bombs
			grid.forEach { cell in
				if cell.isBomb {
					cell.reveal()
				}
			}
			playSound(Sounds.Explode)
		}
		updateUI()
	}
	
	/// We'd like some noises in our game
	var soundPlayer: AVAudioPlayer?
	/// Asynchronously play some audio file
	/// - Parameter name: The name of the resource
	private func playSound(_ name: String) {
		guard let audioFile = NSDataAsset(name: name)?.data else {
			return
		}
		do {
			soundPlayer = try AVAudioPlayer(data: audioFile)
			guard let player = soundPlayer else { return }
			
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
			try AVAudioSession.sharedInstance().setActive(true)
			
			guard player.prepareToPlay() else { return }
			player.play()

			
		} catch let error {
			print("Cannot play sound. \(error.localizedDescription)")
		}
	}
	
	
	/// Toggle the flag status of a cell
	/// - Parameters:
	///   - x: x position
	///   - y: y position
	func toggleFlag(x: Int, y: Int) {
		if let cell = getCell(x, y) {
			if !cell.isRevealed {
				cell.isMarked = !cell.isMarked
			}
		}
		updateUI()
	}
	
	/// In order to update the UI we need to link to something updatable. Like a flag.
	@Published var update : Bool = false
	
	/// Force a refresh of the consuming UI
	func updateUI() {
		update = !update
	}
	
	/// When we first tap on the grid, there are no bombs set - this ensures the first thing we do isn't to land upon a bomb. So, we need something to populate the grid with the required number of bombs
	/// - Parameters:
	///   - firstMoveX: tapped x position
	///   - firstMoveY: tapped y position
	///   - numberOfBombs: how many bombs to populate the grid with
	func fillWithBombs(firstMoveX: Int, firstMoveY: Int, numberOfBombs: Int) {
		
		//Calculate the index
		let moveIdx = firstMoveY * width + firstMoveX
		
		//for all bombs
		(0..<numberOfBombs).forEach { bombNo in
			
			//Pick a random cell and if it's blank and not our first move cell plonk a bomb in it
			var idx = Int.random(in: 0..<height * width)
			while idx == moveIdx || !grid[idx].isBlank() {
				idx = Int.random(in: 0..<height * width)
			}
			grid[idx].isBomb = true
		}
		
		//Reveal the cell we have tapped upon. Note we don't do multi-reveal with the first move
		grid[moveIdx].reveal()
	}
	
	
	
	/*
		TIMING
	*/
	
	internal var _timeStarted : Date?
	internal var _timeEnded : Date?
	
	func startTimer() {
		_timeStarted = Date()
		_timeEnded = nil
	}
	
	@discardableResult
	func stopTimer() -> String {
		guard _timeEnded == nil else { return "\(timeElapsedInSeconds)" }	//Already stopped
		_timeEnded = Date()
		_timeStarted = _timeStarted ?? _timeEnded
		return "\(timeElapsedInSeconds)"
	}
	
	var timeElapsedInSeconds : Int {
		get {
			let endedTime = _timeEnded ?? Date()
			let startTime = _timeStarted ?? endedTime
			let interval = endedTime.timeIntervalSince(startTime)
			return Int(interval)
		}
	}
}

import SwiftUI

struct Shake: GeometryEffect {
	var amount: CGFloat = 10
	var shakesPerUnit = 3
	var animatableData: CGFloat
	
	func effectValue(size: CGSize) -> ProjectionTransform {
		ProjectionTransform(CGAffineTransform(translationX:
												amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
											  y: 0))
	}
}

extension VStack {
	func shake(_ gameEnded: Bool = false) {
		if gameEnded {
			shake()
		}
	}
	func shake() {
		shake(axis: "x")
		shake(axis: "y")
	}
	func shake(axis : String = "x") {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(axis)")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 2
		var values : [Float] = []
		(1..<20).reversed().forEach { i in
			let f = Float(i)
			var distance = Float.random(in: 1...f)
			if i % 2 == 1 {
				distance = -distance
			}
			values.append(distance)
		}
		animation.values = values
		layer.add(animation, forKey: "shake")
	}
}
