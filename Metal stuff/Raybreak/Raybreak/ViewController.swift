//
//  ViewController.swift
//  Raybreak
//
//  Created by Matt Hogg on 17/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import UIKit
import MetalKit

//This is just a tidy way of defining the colors we are going to use
enum Colors {
	static let wenderlichGreen = MTLClearColorMake(0.0, 0.4, 0.21, 1.0)
}

class ViewController: UIViewController {
	
	var render: Renderer?
	
	var metalView: MTKView {
		return view as! MTKView
	}
	
	var device:			MTLDevice!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		//Create the representation of the GPU
		metalView.device = MTLCreateSystemDefaultDevice()
		device = metalView.device
		render = Renderer(device: device)
		

		//Clear the screen to the color
		metalView.clearColor = Colors.wenderlichGreen

		//Below in the extension we are handling the drawing, so we need to let the view know the delegate (i.e. me)
		metalView.delegate = render
//
//		//Make the command buffers
//		commandQueue = device.makeCommandQueue()
		

	}


}



