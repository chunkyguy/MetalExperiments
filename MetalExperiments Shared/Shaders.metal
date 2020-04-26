//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VertexIn {
  float4 position;
  float4 normal;
};

struct VertexOut {
  float4 position [[position]];
  float3 eye;
  float3 normal;
};

struct Uniforms {
  float4x4 mvpMatrix;
  float3x3 nMatrix;
};

vertex VertexOut vert_main(
  const device VertexIn *vertices [[buffer(0)]],
  constant Uniforms *uniforms [[buffer(1)]],
  uint vid [[vertex_id]]
)
{
  VertexOut out;
  out.position = uniforms->mvpMatrix * vertices[vid].position;
  out.normal = uniforms->nMatrix * vertices[vid].normal.xyz;
  return out;
}

fragment float4 frag_main(VertexOut v [[stage_in]])
{
  return float4(1.0);
}
