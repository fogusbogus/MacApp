//
//  Flake.swift
//  Snowbound
//
//  Created by Matt Hogg on 27/11/2022.
//

import Foundation
import SwiftUI

class Snow : ObservableObject {
	
	var flakes: [Flake] = []							///Our snowflakes

	@Published var updated : Bool = false				///Tell the container to update
	
	/// Move the snowflakes to their next position
	func move() {
		self.flakes.forEach { flake in
			flake.move()
		}
		
		///Now we've moved them, let the owner know they can update
		updated = !updated
	}
	
	/// Initializer
	/// - Parameter noFlakes: How many snowflakes do we want?
	init(noFlakes: Int = 500) {
		
		///Each flake randomizes itself
		(0..<noFlakes).forEach { _ in
			flakes.append(Flake())
		}
	}
	
	/// Draw the snowflakes to a given context
	/// - Parameters:
	///   - context: The context to draw to
	///   - size: How large is the context. Snowflakes are drawn and positioned to scale.
	func drawToCanvas(context: GraphicsContext, size: CGSize) {
		flakes.forEach { flake in
			flake.draw(context: context, size: size)
		}
	}
	
}

/// Snowflake
class Flake {
	
	/// Initializer
	init() {
		///Let's have some random values for our snowflake
		randomize()
	}
	
	func randomize() {
		
		///The images are in our assets file. They are identified: Flakes/1, Flakes/2 and Flakes/3. If you want to add more,change the randomizer below
		self.image = "Flakes/\((1...3).randomElement()!)"
		
		///Speed is how many increments (in % of canvas estate height) for the y position
		self.speed = Double((1...5).randomElement()!) / 10.0
		
		///The snowflake itself has a left/right motion as it falls, this decides how quick it does that
		self.alphaIncrementer = Double((0..<100).randomElement()! - 50) / 10.0
		
		///The anchor x point
		self.xPos = Double((0...100).randomElement()!)
		
		///As a percentage (n...100), where is the snowflake located?
		self.location = CGPoint(x: CGFloat(self.xPos), y: CGFloat(Double((0...100).randomElement()!)) - widthSplit)
		
		///Snowflakes come in different sizes
		self.magnification = Double((1...100).randomElement()!) / 40.0
	}
	
	var speed = 0.0					///How quickly the snowflake falls
	var alpha = 0.0					///Degree of rotation in the x-axis
	var alphaIncrementer = 1.0		///Which way the x-axis rotation happens and how quickly
	var xPos = 0.0					///Horizontal anchor point
	
	var location = CGPoint.zero		///Where the snowflake lies on our canvas
	
	var image: String = ""			///Which snowflake are we? We have a number to choose from in the assets
	
	var magnification = 1.0			///How big or small is our snowflake
	
	let widthSplit = 48.0			///A magnification of 1 is equal to the canvas width divided by this value
	
	let halfPi = 180.0 * Double.pi	///As we use this value to calculate our x-axis shift, make it a constant
	
	/// Move the snowflake around the canvas
	func move() {
		
		location.y += speed
		alpha = alpha + alphaIncrementer
		
		let beta = Double(alpha) / halfPi
		location.x = xPos + 25.0 * sin(beta)
		
		///Are we off-screen (vertically). If so, we need a new flake to fall
		if location.y > 100.0 {
			randomize()
			location.y = -widthSplit
		}
	}
	
	/// Let's draw the snowflake to a canvas context
	/// - Parameters:
	///   - context: Graphics context to draw to
	///   - size: The size of the graphics context
	func draw(context: GraphicsContext, size: CGSize) {
		let img = Image(image)
		let rect = CGRect(x: Int(location.x * Double(size.width) / 100.0), y: Int(location.y * Double(size.height) / 100.0), width: Int(size.width / widthSplit * magnification), height: Int(size.width / widthSplit * magnification))
		context.draw(img, in: rect)
	}
}
