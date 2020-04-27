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
  float3 La, Ld, Ls; // intensity
};
constant Light gLight = {
  .position = { 5.0, 5.0, 2.0, 1.0f },
  .La = { 0.1, 0.1, 0.1 },
  .Ld = { 1.0, 1.0, 1.0 },
  .Ls = { 1.0, 1.0, 1.0 },
};

struct Material {
  float3 Ka, Kd, Ks; // Reflectivity
  float shine;
};
constant Material gMaterial = {
  .Ka = { 0.9, 0.5, 0.3 },
  .Kd = { 0.9, 0.5, 0.3 },
  .Ks = { 0.8, 0.8, 0.8 },
  .shine = 1.0
};

struct Uniforms {
  float4x4 mvMatrix;
  float3x3 nMatrix;
  float4x4 mvpMatrix;
};

struct VertexIn {
  float4 position;
  float3 normal;
};

struct VertexOut {
  float4 position [[position]];
  float4 color [[flat]] ;
};

float4 phong(const float4 wPos, const float3 wNormal);

vertex VertexOut vert_main(const device VertexIn *vertices [[buffer(0)]], constant Uniforms *uniforms [[buffer(1)]], uint vid [[vertex_id]])
{
  float4 wPos = uniforms->mvMatrix * vertices[vid].position;
  float3 wNormal = normalize(uniforms->nMatrix * vertices[vid].normal);
  VertexOut out {
    .position = uniforms->mvpMatrix * vertices[vid].position,
    .color = phong(wPos, wNormal)
  };
  return out;
}

fragment float4 frag_main(VertexOut v [[stage_in]])
{
  return v.color;
}

float4 phong(const float4 wPos, const float3 wNormal)
{
  // ambient light
  float3 ambient = gLight.La * gMaterial.Ka;

  // diffuse light
  float3 wLightDir = normalize(float3(gLight.position - wPos)); // surface -> light
  float diffuseFactor = max(0.0, dot(wLightDir, wNormal));
  float3 diffuse = gLight.Ld * gMaterial.Kd * diffuseFactor;

  // specular light
  float3 wEye = normalize(-wPos.xyz); // surface -> eye
  float3 wReflect = reflect(-wLightDir, wNormal); // reflection vector
  float3 spec = float3(0.0);
  if (diffuseFactor > 0.0) {
    spec = gLight.Ls * gMaterial.Ks * pow(max(0.0, dot(wReflect, wEye)), gMaterial.shine);
  }

  return float4(ambient + diffuse + spec, 1.0);
}

