//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Vertex {
  float4 position [[position]];
  float4 color;
};

vertex Vertex vert_main(device Vertex *vertices[[buffer(0)]], uint vid [[vertex_id]])
{
  return vertices[vid];
}

fragment float4 frag_main(Vertex v [[stage_in]])
{
  return v.color;
}
