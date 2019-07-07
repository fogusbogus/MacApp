//
//  Renderer.swift
//  Raybreak
//
//  Created by Matt Hogg on 18/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
	let device: MTLDevice
	let commandQueue: MTLCommandQueue
	
	var vertices: [Float] = []
	
	init(device: MTLDevice) {
		self.device = device
		commandQueue = device.makeCommandQueue()!
		super.init()
		setupVertices()
		buildModel()
		buildPipelineState()
	}
	
	var pipelineState: MTLRenderPipelineState?
	var vertexBuffer: MTLBuffer?

	func buildModel() {
		
	}
	
	func buildPipelineState() {
		
	}
	
	func setupVertices() {
		
	}
}

class Triangle: Renderer {
	override init(device: MTLDevice) {
		super.init(device: device)
	}
	
	override func setupVertices() {
		vertices = [
		0,  1,  0,
		-1, -1,  0,
		1, -1,  0
		]
	}
	
	override func buildModel() {
		vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
	}
	
	override func buildPipelineState() {
		let library = device.makeDefaultLibrary()
		let vertexFunction = library?.makeFunction(name: "vertex_shader")
		let fragmentFunction = library?.makeFunction(name: "fragment_shader")
		
		let pipelineDescriptor = MTLRenderPipelineDescriptor()
		pipelineDescriptor.vertexFunction = vertexFunction
		pipelineDescriptor.fragmentFunction = fragmentFunction
		pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		
		do {
			pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
		} catch let error as NSError {
			print("error: \(error.localizedDescription)")
		}
	}
}

extension Renderer : MTKViewDelegate {
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		
	}
	
	func draw(in view: MTKView) {
		guard let drawable = view.currentDrawable,
			let pipelineState = pipelineState,
			let descriptor = view.currentRenderPassDescriptor else {
			return
		}
		
		//Create the command buffer that will contain all of the commands - you can have multiples of these
		let commandBuffer = commandQueue.makeCommandBuffer()
		
		//Render encoder
		let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
		
		//No commands, so just comit the buffer
		commandEncoder?.setRenderPipelineState(pipelineState)
		commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
		commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
		
		commandEncoder?.endEncoding()
		
		commandBuffer?.present(drawable)
		commandBuffer?.commit()
		
	}
}
