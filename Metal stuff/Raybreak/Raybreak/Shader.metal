//
//  Shader.metal
//  Raybreak
//
//  Created by Matt Hogg on 18/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//Also need to define the constants in here
struct Constants {
	float animateBy;
};

struct VertexIn {
	float4 position [[ attribute(0) ]];
	float4 color    [[ attribute(1) ]];
};

struct VertexOut {
	float4 position [[ position ]];
	float4 color;
};

//*HINT* The output of this becomes the input of the next stage in the pipeline
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]) {
	
	VertexOut vertexOut;
	vertexOut.position = vertexIn.position;
	vertexOut.color = vertexIn.color;
	
	return vertexOut;
}

//This will return the color of the fragment
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
	return half4(vertexIn.color);
}
