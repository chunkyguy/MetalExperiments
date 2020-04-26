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

struct Uniforms {
  float4x4 mvpMatrix;
};

vertex Vertex vert_main(
  const device Vertex *vertices [[buffer(0)]],
  constant Uniforms *uniforms [[buffer(1)]],
  uint vid [[vertex_id]]
)
{
  Vertex out;
  out.position = uniforms->mvpMatrix * vertices[vid].position;
  out.color = vertices[vid].color;
  return out;
}

fragment float4 frag_main(Vertex v [[stage_in]])
{
  return v.color;
}
