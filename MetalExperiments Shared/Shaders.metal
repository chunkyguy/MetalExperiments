//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>
#include "WLShaderTypes.h"

using namespace metal;

struct Light {
  float4 position;
  float3 La; // Ambient
  float3 Ld; // Diffuse
};
constant Light gLight = {
  .position = { 5.0, 5.0, 2.0, 0.0f },
  .La = { 0.2, 0.2, 0.2 },
  .Ld = { 1.0, 1.0, 1.0 },
};

struct Material {
  float3 Ka, Kd, Ks; // Reflectivity
  float shine;
};
constant Material gMaterial = {
  .Ka = { 0.3f, 0.3f, 0.3f },
  .Kd = { 0.5f, 0.5f, 0.5f },
  .Ks = { 0.5f, 0.5f, 0.5f },
  .shine = 30.0f
};

struct FragVertex {
  float4 position [[position]];
  float4 wPos;
  float3 wNormal;
  float2 texCoords;
};

float3 getColor(const float4 position, const float3 normal, const Light light)
{
  float3 ambient = light.La * gMaterial.Ka;
  
  float3 diffuse = float3(0.0f);
  float3 s = normalize(float3(light.position) - float3(position));
  float3 n = normalize(normal);
  float cosine = max(0.0, dot(s, n));
  diffuse = gMaterial.Kd * cosine * max(0.0f, dot(normal, s.xyz));
  
  float3 spec = float3(0.0);
  float3 v = normalize(-position.xyz);
  float3 h = normalize(v + s);
  spec = gMaterial.Ks * pow(max(0.0f, dot(h, n)), gMaterial.shine);
  
  return ambient + diffuse + spec;
}

vertex FragVertex vert_main(const device WLVertex *vertices [[buffer(0)]], constant WLUniforms &uniforms [[buffer(1)]], uint vid [[vertex_id]]) {
  float4 wPos = uniforms.mvMatrix * vertices[vid].position;
  float3 wNormal = normalize(uniforms.nMatrix * vertices[vid].normal);
  FragVertex out {
    .position = uniforms.mvpMatrix * vertices[vid].position,
    .wPos = wPos,
    .wNormal = wNormal,
    .texCoords = vertices[vid].texCoords
  };
  return out;
}

fragment float4 frag_main(FragVertex vert [[stage_in]], texture2d<half> tex0 [[ texture(0) ]])
{
  float4 lightColor = float4(getColor(vert.wPos, vert.wNormal, gLight), 1.0f);
  constexpr sampler smplr {mag_filter::linear, min_filter::linear};
  float4 texColor = float4(tex0.sample(smplr, vert.texCoords));
  return lightColor + texColor;
}
