//
//  ContentView.swift
//  TetrisClone
//
//  Created by Matt Hogg on 20/02/2021.
//

import SwiftUI

struct ContentView: View {
	
	var shapeSize = 12
	
	var blockSize : CGSize {
		get {
			return CGSize(width: shapeSize, height: shapeSize)
		}
	}
	
	var gapSize : Int {
		get {
			return Int(shapeSize / 4)
		}
	}
	var bottomLineHeight = 1
	
	var leftRightLineSize : CGSize {
		get {
			//4, padding
			//rowSize * rowHeight
			return CGSize(width: gapSize, height: game.rowCount * (Int(blockSize.height) + gapSize))
		}
	}
	
	var gamePlayArea : CGSize {
		get {
			//Left line, padding, cols * (shapeSize + padding), right line
			
			let w = Int(leftRightLineSize.width) + gapSize + game.colCount * (Int(blockSize.width) + gapSize) + Int(leftRightLineSize.width)
			let h = (Int(blockSize.height) + gapSize) * game.rowCount + bottomLineHeight
			return CGSize(width: w, height: h)
		}
	}
	
	@ObservedObject var game : Game = Game()
	
	let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
	
	
	var body: some View {
		
		VStack {
			//Game area
			//HStack {
			HStack(alignment: .top) {
				VStack(alignment: .leading, spacing: 0) {
					
					ForEach(game.updatedGrid(), id:\.self) {
						gridLine in
						HStack(alignment: .center, spacing: 4) {
							Rectangle()
								.fill(Color.primary)
								.frame(width:4, height:.infinity)
							ForEach(gridLine, id:\.self) {
								item in
								Rectangle()
									.fill(item)
									.frame(width: CGFloat(shapeSize), height: CGFloat(shapeSize))
									.scaledToFit()
							}
							Rectangle()
								.fill(Color.primary)
								.frame(width:4, height:.infinity)
						}
					}
				}
				ScoreArea(contentView: self)
				Spacer()
			}
			.frame(height: CGFloat(game.rowCount * 20))
			Rectangle()
				.fill(Color.primary)
				.frame(width:.infinity, height:1)
			//}
			Spacer()
			VStack(spacing: 24) {
				HStack(spacing: 48) {
					Button(action: {
						game.moveLeft()
					}, label: {
						Image(systemName: "arrow.left.circle.fill")
							.resizable()
							.frame(width: 48, height: 48, alignment: .center)
							.scaledToFit()
					})
					Button(action: {
							game.rotateLeft()					}, label: {
								Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
									.resizable()
									.frame(width: 48, height: 48, alignment: .center)
									.scaledToFit()
							})
					Button(action: {
						game.moveRight()
					}, label: {
						Image(systemName: "arrow.right.circle.fill")
							.resizable()
							.frame(width: 48, height: 48, alignment: .center)
							.scaledToFit()
					})
				}
				HStack(spacing: 48) {
					Button(action: {
						game.forceDropShape()
					}, label: {
						Image(systemName: "arrow.down.circle.fill")
							.resizable()
							.frame(width: 48, height: 48, alignment: .center)
							.scaledToFit()
						
					})
				}
			}
		}
		//.padding(.leading, 4)
		.onReceive(timer, perform: { _ in
			game.runTimer()
		})
		
		
	}
}

struct ShapeStack : View {
	
	var shapes : [Tetromino]
	var shapeSize = 16
	
	var shapeCount : Int {
		get {
			if shapes.count > 3 {
				return 3
			}
			return shapes.count
		}
	}
	
	var body: some View {
		
		VStack(alignment: .center, spacing: 24) {
			ForEach(0..<shapeCount, id:\.self) {
				shapeIdx in
				
				let shape = shapes[shapeIdx]
				VStack(alignment: .center, spacing: 4) {
					let pts : [(Int,Int)] = shape.type.shapePoints(rotation: shape.rotation)
					let xFrom = pts.map { (xy) -> Int in
						return xy.0
					}.min() ?? 0
					let xTo = pts.map { (xy) -> Int in
						return xy.0
					}.max() ?? -1
					let yFrom = pts.map { (xy) -> Int in
						return xy.1
					}.min() ?? 0
					let yTo = pts.map { (xy) -> Int in
						return xy.1
					}.max() ?? -1

					ForEach(yFrom...yTo, id:\.self) {
						y in
						HStack(alignment: .center, spacing: 4) {
							ForEach(xFrom...xTo, id:\.self) { x in
								//Let's see if our line contains the x value
								
								let isSet = pts.contains { (lineXY) -> Bool in
									return lineXY.0 == x && lineXY.1 == y
								}
								
								Rectangle()
									.fill(isSet ? shape.color : Color(UIColor.systemBackground))
									.frame(width: CGFloat(shapeSize), height: CGFloat(shapeSize))
									.scaledToFit()
							}
						}
					}
				}
			}
		}
	}
}

struct ScoreLine : View {
	
	var title : String
	var score : String
	
	var body : some View {
		Text(title)
		Text(score)
		Text("")
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ContentView()
				.preferredColorScheme(.dark)
			
			//ContentView()
		}
	}
}

struct ScoreArea: View {
	var contentView : ContentView
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				
				ScoreLine(title: "High Score", score: contentView.game.displayHighScore)
				ScoreLine(title: "Score", score: contentView.game.displayScore)
				
			}
			VStack(alignment: .center) {
				if contentView.game.gameOver {
					Text("GAME OVER!")
					Text("")
					Button(action: {
						contentView.game.restart()
					}, label: {
						Text("PLAY AGAIN")
							.border(Color.secondary, width: 1)
					})
				}
				else {
					ShapeStack(shapes: contentView.game.nextShapes, shapeSize: contentView.shapeSize)
				}
				
			}
		}
	}
}
