//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Light {
  float4 position;
  float3 diffuse;
  float3 intensity;
};

constant Light gLight = {
  .position = { 5.0, 5.0, 2.0, 1.0f },
  .diffuse = { 0.9, 0.5, 0.3 },
  .intensity = { 1.0, 1.0, 1.0 }
};

struct VertexIn {
  float4 position;
  float3 normal;
};

struct VertexOut {
  float4 position [[position]];
  float3 lightIntensity;
};

struct Uniforms {
  float4x4 mvMatrix;
  float3x3 nMatrix;
  float4x4 mvpMatrix;
};

vertex VertexOut vert_main(
  const device VertexIn *vertices [[buffer(0)]],
  constant Uniforms *uniforms [[buffer(1)]],
  uint vid [[vertex_id]]
)
{
  float4 eyePos = uniforms->mvMatrix * vertices[vid].position;
  float3 eyeNormal = normalize(uniforms->nMatrix * vertices[vid].normal);
  float3 lightDir = normalize(float3(gLight.position - eyePos));

  VertexOut out {
    .position = uniforms->mvpMatrix * vertices[vid].position,
    .lightIntensity = gLight.diffuse * gLight.intensity * max(0.0, dot(lightDir, eyeNormal))
  };
  return out;
}

fragment float4 frag_main(VertexOut v [[stage_in]])
{
  return float4(normalize(v.lightIntensity), 1.0);
}
