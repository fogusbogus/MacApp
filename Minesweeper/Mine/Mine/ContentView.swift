//
//  ContentView.swift
//  Mine
//
//  Created by Matt Hogg on 29/05/2021.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
	
	/// The grid is the game
	@ObservedObject var grid : Grid = Grid()
	/// To show a dialog we need a state var that triggers it
	@State var restartGameAlert = false
	
	
	/// Initializer - set up the cell size
	init() {
		let sc = UIScreen.main.bounds.size
		let xPerW = sc.width / CGFloat(grid.width + 2)
		let yPerH = sc.height / CGFloat(grid.height + 2)
		_cellSize = xPerW < yPerH ? xPerW : yPerH
	}
	
	/// Cell size
	private var _cellSize = CGFloat.leastNormalMagnitude
	/// Property accessor for cell size (read only)
	var cellSize : CGFloat {
		get {
			return _cellSize
		}
	}
	
	var body: some View {
		//Stack needs to start somewhere after the bezel
		Spacer()
			.frame(height:cellSize * 3)
		
		//Top-down orientation
		VStack {
			VStack(spacing: 0) {
				
				//This is our grid
				ForEach((0..<grid.height), id: \.self) { y in
					HStack(spacing: 0) {
						ForEach((0..<grid.width), id: \.self) { x in
							Image(grid.getCell(x, y)?.image ?? "Unrevealed")
								.resizable()
								.scaledToFit()
								.frame(width: cellSize, height: cellSize)
								.onTapGesture {
									grid.reveal(x: x, y: y)
									grid.updateUI()
									
								}
								.onLongPressGesture {
									grid.toggleFlag(x: x, y: y)
								}
								.frame(width: cellSize, height: cellSize, alignment: .center)
						}
					}
				}
			}
			.overlay(GameOver(over: grid.gameEnded()))
			Spacer()
				.frame(height:cellSize * 2)

			//Now our selector
			HStack {
				Spacer()
				Image("Unrevealed")
					.resizable().scaledToFit()
					.frame(width:cellSize * 2, height:cellSize * 2)
					.padding(8)
					.border(Color.secondary, width: CGFloat(4) * grid.revealTypeBorderWidthMultiplier(.single))
					.onTapGesture {
						grid.revealType = .single
					}
				Spacer()
				VStack(spacing: 0) {
					ForEach((0..<3), id:\.self) { idx in
						HStack(spacing: 0) {
							Image("Unrevealed")
								.resizable().scaledToFit()
								.frame(width:cellSize, height:cellSize)
							Image("Unrevealed")
								.resizable().scaledToFit()
								.frame(width:cellSize, height:cellSize)
							Image("Unrevealed")
								.resizable().scaledToFit()
								.frame(width:cellSize, height:cellSize)
						}
					}
				}
				.padding(8)
				.border(Color.secondary, width: CGFloat(4) * grid.revealTypeBorderWidthMultiplier(.multi))
				.onTapGesture {
					grid.revealType = .multi
				}
				Spacer()
				Image("Flag")
					.resizable().scaledToFit()
					.frame(width:cellSize * 2, height:cellSize * 2)
					.padding(8)
					.border(Color.secondary, width: CGFloat(4) * grid.revealTypeBorderWidthMultiplier(.flag))
					.onTapGesture {
						grid.revealType = .flag
					}
				Spacer()

			}
			Spacer()
			Button("Play again") {
				restartGameAlert = !grid.gameEnded()
				if !restartGameAlert {
					grid.reset()
				}
			}
			.font(.title)
			.padding(cellSize)
			.cornerRadius(cellSize)
			.background(Color.accentColor)
			.foregroundColor(Color(UIColor.systemBackground))
			.border(Color.primary)
			.alert(isPresented: $restartGameAlert, content: {
				Alert(
					title: Text("Play again"),
					message: Text("Are you sure you want to restart?"),
					primaryButton: .destructive(Text("OK"), action: {
						grid.reset()
					})
					,
					secondaryButton: .cancel()
				)
			})
			Spacer().frame(height: cellSize * 3)
			
		}
		.shake(grid.gameEnded())
	}
}

struct GameOver : View {
	var over : Bool
	
	var body : some View {
		if over {
			Text("G A M E   O V E R")
				.font(.title)
				.fontWeight(.bold)
				.scaledToFit()
				.shadow(radius: 10)
				.padding(48.0)
				.foregroundColor(Color(UIColor.systemBackground))
				.background(Color.secondary)
				
		}
		else
		{
			Spacer()
		}
	}
}

struct MineSquare : View {
	
	@State var square : Cell
	var squareSize : CGFloat
	
	var body : some View {
		Image(square.image, label: Text(""))
			.resizable()
			.scaledToFit()
			.frame(width: squareSize, height: squareSize)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
