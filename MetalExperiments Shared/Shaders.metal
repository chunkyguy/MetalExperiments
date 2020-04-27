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
  float3 La; // Ambient
  float3 Ld; // Diffuse
};

constant Light gLight[] = {
  {
    .position = { 2.0f, 1.2f, 1.0f, 1.0f },
    .La = { 0.0f, 0.2f, 0.2f },
    .Ld = { 0.0f,0.8f,0.8f }
  },
  {
    .position = { 0.6f, 1.2f, 2.9f, 1.0f },
    .La = { 0.0f, 0.0f, 0.2f },
    .Ld = { 0.0f,0.0f,0.8f }
  },
  {
    .position = { -1.6f, 1.2f, 2.2f, 1.0f },
    .La = { 0.2f, 0.0f, 0.0f },
    .Ld = { 0.8f,0.0f,0.0f }
  },
  {
    .position = { -1.6f, 1.2f, -0.2f, 1.0f },
    .La = { 0.0f, 0.2f, 0.0f },
    .Ld = { 0.0f,0.8f,0.0f }
  },
  {
    .position = { 0.6f, 1.2f, -0.9f, 1.0f },
    .La = { 0.2f, 0.2f, 0.2f },
    .Ld = { 0.8f,0.8f,0.8f }
  }
};

struct Material {
  float3 Ka, Kd, Ks; // Reflectivity
  float shine;
};
constant Material gMaterial = {
  .Ka = { 0.9f, 0.5f, 0.3f },
  .Kd = { 0.9f, 0.5f, 0.3f },
  .Ks = { 0.8f, 0.8f, 0.8f },
  .shine = 30.0f
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
  float4 color;
};

float4 phong(const float4 wPos, const float3 wNormal, const int lightIndex);

vertex VertexOut vert_main(const device VertexIn *vertices [[buffer(0)]], constant Uniforms *uniforms [[buffer(1)]], uint vid [[vertex_id]])
{
  float4 wPos = uniforms->mvMatrix * vertices[vid].position;
  float3 wNormal = normalize(uniforms->nMatrix * vertices[vid].normal);
  float4 color = float4(0.0f);
  int totalLights = sizeof(gLight)/sizeof(Light);
  for (int i = 0; i < totalLights; ++i) {
    color += phong(wPos, wNormal, i);
  }
  VertexOut out {
    .position = uniforms->mvpMatrix * vertices[vid].position,
    .color = color
  };
  return out;
}

fragment float4 frag_main(VertexOut v [[stage_in]])
{
  return v.color;
}

float4 phong(const float4 wPos, const float3 wNormal, const int lightIndex)
{
  // ambient light
  float3 ambient = gLight[lightIndex].La * gMaterial.Ka;

  // diffuse light
  float3 wLightDir = normalize(float3(gLight[lightIndex].position - wPos)); // surface -> light
  float diffuseFactor = max(0.0, dot(wLightDir, wNormal));
  float3 diffuse = gLight[lightIndex].Ld * gMaterial.Kd * diffuseFactor;

  // specular light
  float3 wEye = normalize(-wPos.xyz); // surface -> eye
  float3 wReflect = reflect(-wLightDir, wNormal); // reflection vector
  float3 spec = float3(0.0);
  if (diffuseFactor > 0.0) {
    spec = gLight[lightIndex].Ld * gMaterial.Ks * pow(max(0.0, dot(wReflect, wEye)), gMaterial.shine);
  }

  return float4(ambient + diffuse + spec, 1.0);
}

