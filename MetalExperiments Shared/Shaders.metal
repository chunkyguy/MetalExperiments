//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Light {
  float3 dir, ambient, diffuse, specular;
};

constant Light gLight = {
  .dir = { 0.13, 0.72, 0.68 },
  .ambient = { 0.7, 0.7, 0.05 },
  .diffuse = { 0.9 },
  .specular = { 1.0 }
};

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
  float4x4 mvMatrix;
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
  out.eye = (uniforms->mvMatrix * vertices[vid].position).xyz * -1;
  out.normal = uniforms->nMatrix * vertices[vid].normal.xyz;
  return out;
}

fragment float4 frag_main(VertexOut v [[stage_in]])
{
  float factor = dot(normalize(v.normal), normalize(gLight.dir));
//  float3 eyeDir = normalize(v.eye);
//  float3 halfway = normalize(gLight.dir + eyeDir);

  return float4(gLight.ambient * factor, 1.0);
}
