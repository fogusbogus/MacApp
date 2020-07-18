//
//  Shader.metal
//  Raybreak
//
//  Created by Matt Hogg on 18/07/2020.
//  Copyright © 2020 Matt Hogg. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//*HINT* The output of this becomes the input of the next stage in the pipeline
vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]], uint vertexId [[ vertex_id ]]) {
	return float4(vertices[vertexId], 1);
}

//This will return the color of the fragment
fragment half4 fragment_shader() {
	return half4(1, 0, 0, 1);
}
