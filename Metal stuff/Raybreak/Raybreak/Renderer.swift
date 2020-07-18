//
//  Renderer.swift
//  Raybreak
//
//  Created by Matt Hogg on 18/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
	let device : MTLDevice
	let commandQueue : MTLCommandQueue
	
	//A very simple triangle
//	var vertices: [Triangle] = [
//		Triangle([-1,1,0, -1,-1,0, 1,-1,0], color: TriColors.blue),
//		Triangle([-1,1,0, 1,1,0, 1,-1,0], color: TriColors.yellow)
//	]
	
	var vertices: [Float] = [
		-1,	 1,	 0,
		-1,	-1,	 0,
		 1,	-1,	 0,
		 1,	 1,	 0
	]
	
	var indices : [UInt16] = [
		0, 1, 2,
		2, 3, 0
	]
	
	//We need a pipeline state (shader functions - .metal file) and buffer
	var pipelineState: MTLRenderPipelineState?
	var vertexBuffer: MTLBuffer?
	var indexBuffer: MTLBuffer?
	
	struct Constants {
		var animateBy: Float = 0.0
	}
	
	var constants = Constants()
	
	var time : Float = 0.0
	
	init(device: MTLDevice) {
		self.device = device
		commandQueue = device.makeCommandQueue()!
		super.init()
		
		//Create the buffer
		buildModel()
		
		//Create the pipeline state
		buildPipelineState()
	}
	
	//Create the vertex buffer
	private func buildModel() {
		vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
		indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
	}
	
	//Create the pipeline state (shader functions)
	private func buildPipelineState() {
		//Our shaders need to go into a library
		let library = device.makeDefaultLibrary()
		let vertexFunction = library?.makeFunction(name: "vertex_shader")
		let fragmentFunction = library?.makeFunction(name: "fragment_shader")
		
		//We can now create the pipeline descriptor
		let pipelineDescriptor = MTLRenderPipelineDescriptor()
		pipelineDescriptor.vertexFunction = vertexFunction
		pipelineDescriptor.fragmentFunction = fragmentFunction
		pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		
		//Now let's try it
		do {
			pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
		}
		catch let error as NSError {
			print("Error: \(error.localizedDescription)")
		}
	}
}

//Make this happen every frame
extension Renderer : MTKViewDelegate {
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		
	}
	
	func draw(in view: MTKView) {
		//We will pass our commands in here
		guard
			let drawable = view.currentDrawable,
			let descriptor = view.currentRenderPassDescriptor,
			let indexBuffer = indexBuffer,
			let pipelineState = pipelineState
		else { return }
		
		//This will contain all the commands
		let commandBuffer = commandQueue.makeCommandBuffer()
		
		time += 1 / Float(view.preferredFramesPerSecond)
		
		let animateBy = abs(sin(time)/2 + 0.5)
		constants.animateBy = animateBy
		
		//Make the renderer for our commands
		let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
		
		//The constants structure can be passed too
		commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
		
		//Let's get it out onto the screen
		commandEncoder?.setRenderPipelineState(pipelineState)
		commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
		
		//The command to draw (doesn't happen until the commit - this is telling it a command to draw)
		commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
		
		commandEncoder?.endEncoding()
		commandBuffer?.present(drawable)
		commandBuffer?.commit()
		
		
	}
	
	
}
