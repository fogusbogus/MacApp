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
	float4 position				[[ attribute(0) ]];
	float4 color    			[[ attribute(1) ]];
	float2 textureCoordinates 	[[ attribute(2) ]];
};

struct VertexOut {
	float4 position [[ position ]];
	float4 color;
	float2 textureCoordinates;
};

//*HINT* The output of this becomes the input of the next stage in the pipeline
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]) {
	
	VertexOut vertexOut;
	vertexOut.position = vertexIn.position;
	vertexOut.color = vertexIn.color;
	vertexOut.textureCoordinates = vertexIn.textureCoordinates;
	
	return vertexOut;
}

//This will return the color of the fragment
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
	return half4(vertexIn.color);
}

//For the texture
fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]],
								 texture2d<float> texture [[ texture(0) ]]) {
	constexpr sampler defaultSampler;
	float4 color = texture.sample(defaultSampler, vertexIn.textureCoordinates);
	return half4(color.r, color.g, color.b, 1);
}
