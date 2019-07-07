//
//  Shader.metal
//  Raybreak
//
//  Created by Matt Hogg on 18/06/2019.
//  Copyright © 2019 Matthew Hogg. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 vertex_shader(const device packed_float3 *vertices [[ buffer(0) ]], uint vertexId [[vertex_id]]) {
	return flaot4(vertices[vertexId], 1);
}

fragment half4 fragment_shader() {
	return half4(1, 0, 0, 1);
}
