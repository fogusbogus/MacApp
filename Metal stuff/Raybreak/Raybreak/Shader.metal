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

//*HINT* The output of this becomes the input of the next stage in the pipeline
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]],
							constant Constants &constants [[ buffer(1) ]],
							uint vertexId [[ vertex_id ]]) {
	float4 position = float4(vertices[vertexId], 1);
	position.x += constants.animateBy;
	return position;
}

//This will return the color of the fragment
fragment half4 fragment_shader() {
	return half4(1, 1, 0, 1);
}
